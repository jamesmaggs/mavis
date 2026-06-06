# MAVIS: Affable Verbal Interaction Simulator

Mavis is a chatterbot in the style of those developed mostly in the 1980s and 90s. Mavis simulates real conversation by breaking down input sentences and using them to generate nonsensical responses.

You can find out more about the history of chatterbots here: https://www.simonlaven.com

## Documentation

An [Allium](https://juxt.github.io/allium/) [specification](./docs/allium/mavis.allium) is available.

## Tech Stack

- Java monolith
- htmx frontend
- Deployed on Railway
- Redis for persistent brain
- Potentially a relational DB for account details?

## Architectural Guidelines

- Hexagonal architecture
- Deep modules, loosely coupled
- Input sentences are broken down and the words stored in a markov chain
