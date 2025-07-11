#!/bin/bash

# Get the target directory name (optional argument)
TARGET_DIR=${1:-"."}
TARGET_NAME=$(basename "$TARGET_DIR")

# Go to the target directory if not already in it
if [ "$TARGET_DIR" != "." ]; then
  mkdir -p "$TARGET_DIR"
  cd "$TARGET_DIR" || exit 1
fi

echo "📁 Setting up Python 2D game project in: $(pwd)"

# Create folders
mkdir -p assets/{images,sounds,fonts}
mkdir -p src/{scenes,entities}
mkdir -p config

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install pygame
pip install pygame

# Save requirements
pip freeze > requirements.txt

# Create main.py
cat <<EOF > src/main.py
import pygame
from config.settings import SCREEN_WIDTH, SCREEN_HEIGHT

def main():
    pygame.init()
    screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
    pygame.display.set_caption("$TARGET_NAME")

    clock = pygame.time.Clock()
    running = True

    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False

        screen.fill((0, 0, 0))
        pygame.display.flip()
        clock.tick(60)

    pygame.quit()

if __name__ == "__main__":
    main()
EOF

# Create settings.py
cat <<EOF > config/settings.py
SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
EOF

# Init packages
touch src/scenes/__init__.py
touch src/entities/__init__.py

echo "✅ Done! Your 2D Python game project '$TARGET_NAME' is ready in $(pwd)."
