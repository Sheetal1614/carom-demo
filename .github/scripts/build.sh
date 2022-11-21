#!/bin/bash
version="latest"
if [ $(git tag -l "$version") ]; then
  version="second"
    if [ $(git tag -l "$version") ]; then
      version="third"
      if [ $(git tag -l "$version") ]; then
        git tag -d third
        git push origin :third
        x=$(git rev-parse second)
        git tag -d second
        git push origin :second
        git tag third ${x}
        y=$(git rev-parse latest)
        git tag -d latest
        git push origin :latest
        git tag second ${y}
        git tag latest HEAD
        git push --tags
      else
        x=$(git rev-parse second)
        git tag -d second
        git push origin :second
        git tag third ${x}
        y=$(git rev-parse latest)
        git tag -d latest
        git push origin :latest
        git tag second ${y}
        git tag latest HEAD
        git push --tags
      fi
    else
      z=$(git rev-parse latest)
      git tag -d latest
      git push origin :latest
      git tag second ${z}
      git tag latest HEAD
      git push  origin latest second
    fi
else
    git tag latest HEAD
    git push origin latest
fi
