# cars

A new Flutter project.

## Getting Started

How to run the project
1. Ensure that the latest flutter sdk is installed.
2. Launch intellij or vscode and then open terminal, type the following command
"flutter pub get". execute the command
3. Navigate to lib/app/env.dart and edit as follows: Since the backend runs as microservices,
    we have to configure each url.
    apiBaseURL = 'http://192.168.43.79:8000/' this is for auth
    apiCarBaseURL = 'http://192.168.43.79:8001/'; this is for cars

After this the project is ready, run the project.
