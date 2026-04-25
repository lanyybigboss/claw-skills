#!/bin/bash
#!/bin/bash
# Script to push skills to GitHub

REPO_DIR="/tmp/claw-skills"

echo "🚀 Preparing to push skills repository..."

# Check if SSH key is available
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "⚠️  SSH key not found. Using HTTPS with credential cache..."
    git config credential.helper 'cache'
fi

# Change remote to SSH format if needed
echo "Checking remote configuration..."
git remote get-url origin

echo "Adding all files..."
git add .

echo "Committing changes..."
git commit -m "Update skills repository"

echo "Pushing to GitHub..."
git push origin main

echo "✅ Repository pushed successfully!"
echo ""
echo "Your skills are now available at: https://github.com/lanyybigboss/claw-skills"
echo ""
echo "To clone and use these skills elsewhere:"
echo "git clone https://github.com/lanyybigboss/claw-skills.git"
echo "cd claw-skills"
echo "./scripts/skill-install.sh <skill-name>"