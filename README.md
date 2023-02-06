# Skpr CircleCI Orb

## Resources
[CircleCI Orb Registry Page](https://circleci.com/orbs/registry/orb/skpr/skpr) - The official registry page of this orb for all versions, executors, commands, and jobs described.
[CircleCI Orb Docs](https://circleci.com/docs/2.0/orb-intro/#section=configuration) - Docs for using and creating CircleCI Orbs.

## Known Issues

### Scenario 1

You may get this error when pushing a new PR,

```
The dev version of skpr/skpr@dev:alpha has expired. Dev versions of orbs are only valid for 90 days after publishing.
```

If you see this error, you need to publish a dev:alpha version manually. The fix is to run this:

```
`circleci orb pack ./src | circleci orb validate -`
circleci orb pack ./src | circleci orb publish -  skpr/skpr@dev:alpha
```

### Scenario 2

If you see this error:

```
Error: AUTHORIZATION_FAILURE
```

You'll need to cycle your tokens by creating a new API token in CircleCI and updating the token.

Instructions for achieving this on a local file system:

```
circleci setup
A CircleCI token is already set. Do you want to change it Yes
CircleCI API Token ----------
API token has been set.
CircleCI Host https://circleci.com
CircleCI host has been set.
Setup complete.
Your configuration has been saved to /home/user/.circleci/cli.yml.
```