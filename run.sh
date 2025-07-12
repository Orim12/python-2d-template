#!/bin/bash

# Get the target directory name (optional argument)
TARGET_DIR=${1:-"."}
TARGET_NAME=$(basename "$TARGET_DIR")
CURRENT_DIR_NAME=$(basename "$PWD")

if [ "$TARGET_DIR" != "." ] && [ "$TARGET_DIR" == "$CURRENT_DIR_NAME" ]; then
  echo "⚠️ Warning: You passed the current folder name '$TARGET_DIR' as argument."
  echo "This will create a nested folder inside the current folder."
  echo "Press Ctrl+C to abort or wait 10 seconds to continue..."

  for i in $(seq 10 -1 1); do
    echo -ne "Continuing in $i seconds...\r"
    sleep 1
  done
  echo -e "\nContinuing setup..."
fi

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

# Download CC0 sound assets
echo "🎵 Downloading free CC0-licensed sound effects..."

curl -s -L -o assets/sounds/click.wav "https://cdn.freesound.org/previews/258/258020_4486188-lq.wav"
curl -s -L -o assets/sounds/jump.wav "https://cdn.freesound.org/previews/270/270404_5121236-lq.wav"
curl -s -L -o assets/sounds/bg_music.mp3 "https://cdn.freesound.org/previews/399/399303_5121236-lq.mp3"

# Create credits file
cat <<EOF > CREDITS.md
# 🎵 Sound Credits (All CC0 - Public Domain)

These sounds are free to use in any project (commercial or personal), no attribution required.

- click.wav from: https://freesound.org/people/Kodack/sounds/258020/
- jump.wav from: https://freesound.org/people/LittleRobotSoundFactory/sounds/270404/
- bg_music.mp3 from: https://freesound.org/people/cognito%20perceptu/sounds/399303/

Downloaded automatically from Freesound.org.
EOF

echo "✅ Done! Your 2D Python game project '$TARGET_NAME' is ready in $(pwd)."
