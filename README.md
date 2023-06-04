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

- ### AuthScreen
    - Controllers
    - UI(Views widgets)
    - Models
     JourneyScreen contains the UI screen of creating and deleting a Auths and all it's Functionality as well

- ### JourneyScreen
    - Controllers
    - UI(Views widgets)
    - Models
     JourneyScreen contains the UI screen of creating and deleting a Journey and all it's Functionality as well

- ### TaskScreen
    - Controllers
    - UI(Views widgets)
    - Models
    - src
        - RecievedScreen
            - InteralRecievedScreen
            - ExternalRecievedScreen
        - DeliverScreen
            - InternalDeliverScreen
            - ExternalDeliverScreen

     TaskScreen contains the UI screen of creating and deleting any Tasks and all it's Functionality, also in the TaskSCreen folder there is src folder which contains RecievedScreen
     and DeliverScreen which follows the same hierarchy as well


