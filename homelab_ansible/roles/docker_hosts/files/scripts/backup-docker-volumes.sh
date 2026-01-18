#!/bin/bash

# Configuration
BACKUP_DIR="${BACKUP_DIR:-./docker-backups}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Create backup directory first
mkdir -p "$BACKUP_DIR"

# Now set log file path after directory is created
LOG_FILE="$BACKUP_DIR/backup_${TIMESTAMP}.log"

# Logging function
log() {
    echo -e "${2:-$NC}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}" | tee -a "$LOG_FILE"
}

# Function to find all docker compose projects
find_compose_projects() {
    # Get all containers with compose project labels
    docker ps --filter "label=com.docker.compose.project" \
        --format "{{.Label \"com.docker.compose.project\"}}" | sort -u
}

# Function to get compose file path for a project
get_compose_file() {
    local project=$1
    
    # Try to get the working directory from a container in the project
    local container=$(docker ps --filter "label=com.docker.compose.project=$project" \
        --format "{{.ID}}" | head -n1)
    
    if [ -n "$container" ]; then
        docker inspect "$container" \
            --format '{{index .Config.Labels "com.docker.compose.project.working_dir"}}' 2>/dev/null
    fi
}

# Function to get volumes for a specific project
get_project_volumes() {
    local project=$1
    
    docker volume ls --filter "label=com.docker.compose.project=$project" \
        --format "{{.Name}}"
}

# Function to backup a volume
backup_volume() {
    local volume=$1
    local project=$2
    local backup_file="$BACKUP_DIR/${project}_${volume}_${TIMESTAMP}.tar.gz"
    
    log "  Backing up volume: $volume" "$YELLOW"
    
    # Create a temporary container to backup the volume
    if docker run --rm \
        -v "$volume:/source:ro" \
        -v "$BACKUP_DIR:/backup" \
        alpine \
        tar czfp "/backup/$(basename "$backup_file")" -C /source . 2>>"$LOG_FILE"; then
        
        local size=$(du -h "$backup_file" | cut -f1)
        log "  ✓ Backed up $volume ($size)" "$GREEN"
        return 0
    else
        log "  ✗ Failed to backup $volume" "$RED"
        return 1
    fi
}

# Function to stop compose project
stop_compose_project() {
    local project=$1
    local compose_dir=$2
    
    if [ -n "$compose_dir" ] && [ -d "$compose_dir" ]; then
        log "  Stopping compose project in: $compose_dir" "$YELLOW"
        (cd "$compose_dir" && docker compose down) >> "$LOG_FILE" 2>&1
        return $?
    else
        # Fallback: stop containers by project label
        log "  Stopping containers for project: $project" "$YELLOW"
        docker ps --filter "label=com.docker.compose.project=$project" \
            --format "{{.ID}}" | xargs -r docker stop >> "$LOG_FILE" 2>&1
        return $?
    fi
}

# Function to start compose project
start_compose_project() {
    local project=$1
    local compose_dir=$2
    
    if [ -n "$compose_dir" ] && [ -d "$compose_dir" ]; then
        log "  Starting compose project in: $compose_dir" "$YELLOW"
        (cd "$compose_dir" && docker compose up -d) >> "$LOG_FILE" 2>&1
        return $?
    else
        # Fallback: start containers by project label
        log "  Starting containers for project: $project" "$YELLOW"
        docker ps -a --filter "label=com.docker.compose.project=$project" \
            --format "{{.ID}}" | xargs -r docker start >> "$LOG_FILE" 2>&1
        return $?
    fi
}

# Main execution
main() {
    log "=== Docker Compose Volume Backup Started ===" "$GREEN"
    log "Backup directory: $BACKUP_DIR"
    echo ""
    
    # Find all compose projects
    projects=$(find_compose_projects)
    
    if [ -z "$projects" ]; then
        log "No docker compose projects found running" "$RED"
        exit 1
    fi
    
    log "Found projects:" "$GREEN"
    while IFS= read -r project; do
        log "  - $project"
    done <<< "$projects"
    
    echo ""
    
    # Process each project
    while IFS= read -r project; do
        log "=== Processing project: $project ===" "$GREEN"
        
        # Get compose file location
        compose_dir=$(get_compose_file "$project")
        if [ -n "$compose_dir" ]; then
            log "Compose directory: $compose_dir"
        else
            log "Warning: Could not determine compose directory" "$YELLOW"
        fi
        
        # Get volumes for this project
        volumes=$(get_project_volumes "$project")
        
        if [ -z "$volumes" ]; then
            log "No volumes found for project: $project" "$YELLOW"
            echo ""
            continue
        fi
        
        log "Volumes for $project:"
        while IFS= read -r vol; do
            log "  - $vol"
        done <<< "$volumes"
        
        # Stop the compose project
        log "Stopping project: $project" "$YELLOW"
        if stop_compose_project "$project" "$compose_dir"; then
            log "✓ Project stopped successfully" "$GREEN"
            
            # Backup each volume
            backup_failed=0
            while IFS= read -r volume; do
                if ! backup_volume "$volume" "$project"; then
                    backup_failed=1
                fi
            done <<< "$volumes"
            
            # Small delay to ensure volumes are released
            sleep 2
            
            # Restart the compose project
            log "Starting project: $project" "$YELLOW"
            if start_compose_project "$project" "$compose_dir"; then
                log "✓ Project started successfully" "$GREEN"
            else
                log "✗ Failed to start project: $project" "$RED"
            fi
        else
            log "✗ Failed to stop project: $project" "$RED"
            log "Skipping backup for this project" "$YELLOW"
        fi
        
        echo ""
    done <<< "$projects"
    
    log "=== Backup Completed ===" "$GREEN"
    log "Backups saved to: $BACKUP_DIR"
    log "Log file: $LOG_FILE"
    echo ""
    
    # Display backup summary
    if ls "$BACKUP_DIR"/*_${TIMESTAMP}.tar.gz >/dev/null 2>&1; then
        log "Backup files created:"
        ls -lh "$BACKUP_DIR"/*_${TIMESTAMP}.tar.gz 2>/dev/null | \
            awk '{print "  " $9 " (" $5 ")"}'
    else
        log "No backup files were created" "$YELLOW"
    fi
}

# Run main function
main "$@"
