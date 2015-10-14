#!/usr/bin/env sh

. ./project.sh

WORDPRESS_TAG="4.3.1"

if ! [ -d "$PROJECT_PATH/.git" ]; then
  echo "cloning wordpress sources..."
  if ! xgit clone https://github.com/WordPress/WordPress "$PROJECT_PATH"; then
    echo "git clone failed"
    exit 1
  fi
fi

cd "$PROJECT_PATH"
if [ "`git name-rev --tags --name-only $(git rev-parse HEAD)`" != "$WORDPRESS_TAG" ]; then
  echo "Checkout wordpress version $WORDPRESS_TAG..."
  if ! git fetch || ! git checkout $WORDPRESS_TAG; then
    echo "Failed to change to wordpress version $WORDPRESS_TAG"
    exit
  fi
fi

if ! [ -f "$PROJECT_PATH/wp-config.php" ]; then
  echo "Copy default wp-config..."
  cp "$CONFIG_PATH/wp-config.php" "$PROJECT_PATH/wp-config.php"
fi

xcompose "up -d"
echo "done"
