#!/usr/bin/env bash

cd flutter_module
flutter clean && flutter build aar
cd ../
./gradlew clean  assembleRelease