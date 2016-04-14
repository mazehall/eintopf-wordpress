#!/usr/bin/env sh

. ./project.sh

if ! [ -d "$PROJECT_PATH/web/.git" ]; then
  echo "cloning wordpress sources..."
  cd ${PROJECT_PATH}
  if ! git clone https://github.com/WordPress/WordPress web; then
    echo "git clone failed"
    exit 1
  fi
fi

cd ${PROJECT_PATH}/web
if [ "`git name-rev --tags --name-only $(git rev-parse HEAD)`" != "$WORDPRESS_TAG" ]; then
  echo "Checkout wordpress version $WORDPRESS_TAG..."
  if ! git fetch --tag || ! git checkout $WORDPRESS_TAG; then
    echo "Failed to change to wordpress version $WORDPRESS_TAG"
    exit
  fi
fi

if ! [ -f "$PROJECT_PATH/web/wp-config.php" ]; then
  echo "Copy default wp-config..."
  cp "$CONFIG_PATH/wp-config.php" "$PROJECT_PATH/web/wp-config.php"
fi

xcompose "up -d"
echo "done"
