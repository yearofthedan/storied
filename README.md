# storied

An application for creative writing projects.

## Why is this a thing?

I wanted to have an app to help me write stories, and with three core featues. 
1. [super basic] It provides word processing capabilities
2. [in progress] It works across desktop and mobile devices for when I'm on the road
3. [not done at all] It supports adding and cross referencing contextual notes such as character studies 

Also I was curious to know how fit for purpose Flutter is now.

Also I'm procrastinating from doing some writing 🫠.

## How to play with it

This has not been packaged, nor deployed anywhere yet. It can only be played with by spinning it up locally.

## Tech
### Stack
Storied is a [Flutter](https://flutter.dev/) app. At present it has no backend, as all the content created is stored on the device and I don't have any activities which need to be offloaded currently.

Word processing is provided by [flutter_quill](https://pub.dev/packages/flutter_quill)

CI/CI is via Github Actions ([see the configuration](.github/workflows/flutter.yml)). 

### Dev tasks
#### Initial setup
You need to have Flutter set up ([read the offical docs](https://docs.flutter.dev/get-started/install)). 

Install packages: `flutter pub get`

#### Running the app
You can run the app using standard approaches via the IDE, or command line.

#### Quality - linting, testing
There is a precommit hook in place thanks to [husky](https://pub.dev/packages/husky) which uses [lint_staged](https://pub.dev/packages/lint_staged) to run basic quality checks.

You can also run each tasks manually across the whole project.

Run the tests: `flutter test lib/**/*_test.dart` (nb. the test file pattern is required because the tests and src are collocated)

Format all the things: `dart format --fix .`

Lint like nobody's watching: `dart fix --apply`

#### Bulding the app
The app expects the variable SENTRY_DSN to be defined


