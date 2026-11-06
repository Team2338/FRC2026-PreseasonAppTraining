# FRC 2026 Preseason App Training

## Setting up the environment
1. Install Java 25
2. Install PostgreSQL
3. Install Node.js

## Running the Backend
If you're on windows, run `run-server.ps1`. If you're on mac, run `run-server.sh`.
This is necessary to send information from the scouting app frontend to being saved in the database.

## Your Frontend Tasks
To start working on the frontend, you'll need to:
1. Run `npm install` to install the dependencies
2. Run `npm start` to start the frontend

Then, you can start working on the frontend! Reference GitHub for issues to work on.

Backend Endpoints you might find useful:
| Method | Path                                                                   | Notes                               |
| ------ | ---------------------------------------------------------------------- | ----------------------------------- |
| POST   | `/v1/team/{teamNumber}`                                                | Submit a match (auto-creates event) |
| GET    | `/v1/team/{teamNumber}/gameYear/{gameYear}/event/{eventCode}`          | List matches for event              |
| GET    | `/v1/team/{teamNumber}/gameYear/{gameYear}/event/{eventCode}/download` | CSV export                          |
| PUT    | `/v1/team/{teamNumber}/match/{matchId}/hide`                           | Soft-hide a match                   |
| PUT    | `/v1/team/{teamNumber}/match/{matchId}/unhide`                         | Restore                             |

No AI tools are allowed for this project.
