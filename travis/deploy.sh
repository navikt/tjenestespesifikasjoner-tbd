#!/bin/bash -e
if [ "$TRAVIS_BRANCH" = 'master' ] && [ "$TRAVIS_PULL_REQUEST" == 'false' ]; then
    echo "Importing GPG key into keyring"
    gpg --fast-import travis/codesigning.asc

    TIME=$(TZ="Europe/Oslo" date +%Y.%m.%d-%H.%M)
    COMMIT=$(git rev-parse --short=12 HEAD)
    VERSION="1.$TIME-$COMMIT"
    echo "Setting version $VERSION"

    mvn -B versions:set -DnewVersion="$VERSION"
    mvn -B versions:commit

    echo "Running release"
    mvn -T 12 -B --settings travis/settings.xml deploy -Prelease -DskipTests=true
fi