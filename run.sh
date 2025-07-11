#!/bin/bash

# Set the project name (use current directory name if not specified)
PROJECT_NAME=${1:-"my_2d_game"}

# Create base directory
mkdir -p "$PROJECT_NAME"/{assets/{images,sounds,fonts},src/{scenes,entities},config}

cd "$PROJECT_NAME" || exit

# Create a virtual environment
python3 -m venv venv
source venv/bin/activate

# Install pygame
pip install pygame

# Freeze requirements
pip freeze > requirements.txt

# Create main Python files
cat <<EOF > src/main.py
import pygame
from config.settings import SCREEN_WIDTH, SCREEN_HEIGHT

def main():
    pygame.init()
    screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
    pygame.display.set_caption("My 2D Game")

    clock = pygame.time.Clock()
    running = True

    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False

        screen.fill((0, 0, 0))  # Black background
        pygame.display.flip()
        clock.tick(60)

    pygame.quit()

if __name__ == "__main__":
    main()
EOF

cat <<EOF > config/settings.py
SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
EOF

touch src/scenes/__init__.py
touch src/entities/__init__.py

# Final message
echo "✅ Python 2D game project '$PROJECT_NAME' is ready."
