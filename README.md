# Serverless Aps
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

This pull request should include a folder in the root of the repository which 
contains the following files:

- `manifest.yaml`: File which holds metadata about serverless application. Must 
  contain the following keys:
  - `name` (String): Name of app
  - `tagline` (String): Short description of serverless application
  - `tags` (List[String]): List of tags which are relevant to the application
  - `categories` (List[String]): List of categories to sort the app into. 
       Select from the following:\[Analytics, API, Automation, Entertainment, Internet of Things, Utilities, Virtual Assistant, Other\]
  - `author` (String): In format `NAME <EMAIL>`
  - `maintainer` (String): Same format as `author`
- `README.md`: Holds longer description of serverless application
- `logo.png`: Logo for serverless application
- `screenshots/`: (Optional) Directory which contains any screenshots
- `deployment/`: Directory which holds Kubernetes resource files

A member of the team will review your pull request and add your application in 
no time.
