# Serverless Example NodeJS
Example NodeJS serverless application.

# Table Of Contents
- [Overview](#overview)
- [Endpoints](#endpoints)

# Overview
NodeJS express app.

# Endpoints
HTTP API.  
GET requests pass data via URL query parameters.  
All other HTTP methods pass data via JSON encoded bodies.  
Responses are JSON formatted.  

## `GET /time`
Request: None

Response:

- `epoch` (Number): Unix time

## `POST /calculate/add`
Request:

- `lhs` (Number): First number to add
- `rhs` (Number): Second number to add

Response:

- `result` (Number): Numbers added together

## `GET /health`
Request: None

Response: 

- `ok` (Boolean): Indicates if server is okay
