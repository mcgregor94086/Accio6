#!/bin/bash

# Store the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$SCRIPT_DIR/.."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to check for specific error patterns
check_for_errors() {
    local file=$1
    local errors=0
    
    # Check for common SwiftData predicate errors
    if grep -q "Cannot convert value of type.*Predicate" "$file"; then
        echo -e "${RED}Found predicate conversion error in $file${NC}"
        errors=$((errors+1))
    fi
    
    # Check for UUID comparison errors
    if grep -q "Cannot convert.*UUID.*to expected argument type" "$file"; then
        echo -e "${RED}Found UUID conversion error in $file${NC}"
        errors=$((errors+1))
    fi
    
    # Check for missing view errors
    if grep -q "Cannot find.*View.*in scope" "$file"; then
        echo -e "${RED}Found missing view error in $file${NC}"
        errors=$((errors+1))
    fi
    
    return $errors
}

# Main verification
echo "Running build verification..."

# Build the project
xcodebuild clean build -scheme Accio6 -destination 'platform=iOS Simulator,name=iPhone 15 Pro' | tee build.log

# Check build log for errors
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Build successful${NC}"
else
    echo -e "${RED}Build failed${NC}"
    check_for_errors build.log
    exit 1
fi

# Run tests
xcodebuild test -scheme Accio6 -destination 'platform=iOS Simulator,name=iPhone 15 Pro' | tee test.log

# Check test results
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Tests passed${NC}"
else
    echo -e "${RED}Tests failed${NC}"
    check_for_errors test.log
    exit 1
fi

# Cleanup
rm build.log test.log

echo -e "${GREEN}Verification complete${NC}"