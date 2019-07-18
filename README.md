# Serverless Apps
Open repository where serverless applications can be submitted to Knative Scout.

# Table Of Contents
- [Overview](#overview)
- [Contributing](#contributing)

# Overview
All applications which are available through Knative Scout are submitted to
this repository.

Open a pull request to submit your own serverless application. See 
[contributing](#contributing) section for more details.

# Contributing
Submit an application to Knative Scout by creating a pull request.  

The pull request should include a folder with your app's name.

The `contribute/new.sh` script will create this folder's basic structure.

Run the script by providing your new app's name as an argument:

```
% ./contribute/new.sh "My Awesome App"
```

The script will ask you a few questions about your app.  
It will then create a directory and a `manifest.yaml` file for your app.

It is up to you to create the rest of the files:

- `README.md`: Holds longer description of serverless application
- `logo.png`: Logo for serverless application
- `screenshots/`: (Optional) Directory which contains any screenshots
- `deployment/`: Directory which holds YAML Kubernetes resource files

A member of the team will review your pull request and add your application in 
no time.

The `contribute/new.sh` script creates a `manifest.yaml` file. This file must 
follow the schema:

- `name` (String): Name of app
- `tagline` (String): Short description of serverless application
- `tags` (List[String]): List of tags which are relevant to the application
- `categories` (List[String]): List of categories to sort the app into. Can 
   only include the following values:
   - `analytics`
   - `automation`
   - `entertainment`
   - `hello world`
   - `internet of things`
   - `utilities`
   - `virtual assistant`
   - `other`
