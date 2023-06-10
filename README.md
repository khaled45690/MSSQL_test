# MSSQL_test

## this is a project to test connection between MSSQL and flutter app directly

## as it will be the sample for a freelance project in the future


## Getting Started

this project follows the Feature first approach
which means I split the project folder into Feature folder each folder contain 
- Controllers
- UI(Views widgets)
- Models

there is the same structure for the whole application as there are some widgets are shared across the whole application


## DataTypes Folder
Consist of all the classes that represent custom datatypes that used through the whole application


## Feature Folder
Consist of all the Features in the application like

- ### [AuthScreen](./lib/src/Feature/AuthScreen/AuthScreen.dart)
    - [Controllers](./lib/src/Feature/AuthScreen/Controler/AuthScreenController.dart)
    - [UI(Views widgets)](./lib/src/Feature/AuthScreen/Widgets)

    ##### AuthScreen contains the UI screen of creating and deleting a Auths and all it's Functionality as well


- ### [JourneyScreen](./lib/src/Feature/JourneyScreen/JourneyScreen.dart)
    - [Controllers](./lib/src/Feature/JourneyScreen/Controller/JourneyScreenController.dart)
    - [UI(Views widgets)](./lib/src/Feature/JourneyScreen/Widgets)

#####   JourneyScreen contains the UI screen of creating and deleting a Journey and all it's Functionality as well

- ### [TaskScreen](./lib/src/Feature/TaskScreen/TaskScreen.dart)
    - [Controllers](./lib/src/Feature/TaskScreen/Controller/TaskScreenController.dart)
    - [UI(Views widgets)](./lib/src/Feature/TaskScreen/Widgets)
    - [Models](./lib/src/Feature/TaskScreen)
    - src
        - [RecievedScreen](./lib/src/Feature/TaskScreen/src/ReceiveScreen/ReceiveScreen.dart)
            - [InteralRecievedScreen](./lib/src/Feature/TaskScreen/src/ReceiveScreen/InternalReceive)
            - [ExternalRecievedScreen](./lib/src/Feature/TaskScreen/src/ReceiveScreen/ExternalReceive)
        - [DeliverScreen](./lib/src/Feature/TaskScreen/src/DeliverTaskScreen/DeliverTaskScreen.dart)
            - [InternalDeliverScreen](./lib/src/Feature/TaskScreen/src/DeliverTaskScreen/src/InternalDeliverScreen)
            - [ExternalDeliverScreen](./lib/src/Feature/TaskScreensrc/DeliverTaskScreen/src/ExternalDeliverScreen)

     ## Note:-

     TaskScreen contains the UI screen of creating and deleting any Tasks and all it's Functionality, also in the TaskScreen folder there is src folder which contains RecievedScreen
     and DeliverScreen which follows the same hierarchy as well there are links provided to folders to 


