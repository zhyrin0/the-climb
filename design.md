# Design

**Theme**: Collaborate with AI  
**Pitch**: You have to climb higher by helping a plant grow in the right direction.  
**Idea**: You need to climb up, but there are no platforms or the platforms are unstable. There is a plant at the bottom of the level that wants to grow and has a behaviour of growing. You can influence it to grow in a way that helps you get up. You need the plant AI's help to get up, and you'll need to help the plant AI to defend it from environmental hazards.

## The Plant
### Default Behaviour
- The plant starts dormant, it needs to be woken up. Sometimes it also gets tired from all the growing :)
- An awake plant starts growing upwards, when it reaches a new uninhabitad platform, it creates an overgrown platform
- A flower that successfully reached a new platfrom blooms fully, and the platform creates a new bud
- Following sunlight
### Player Influence
- Block out sunlight
- Plant grafting to give it different abilities
- Watering to start new vine
- Creating new light source to influence growth direction
### Hazards
- Bugs eating the vines

## Game Elements
### Must Have
- Platformer movement (left, right, jucy feeling jump and fall) ✔️
- Platforms you can jump up on, and maybe even fall through ✔️
- Camera that follows the player
- A plant that can grow upwards and create platforms
- A level that cannot be traversed by letting the plant AI do it's thing alone
### Should Have
- Platforms that are naturally generated, in different states of usability
- Ways to influence the plant
	- Watering to start new vine - _if not already blooming_
	- Creating new light sources, changing growth direction
### Could Have
- Small anchor points, too small for player, big enough to let plant grow further
- Platforms that produce vine ladders when after becoming flowery - _maybe a grafting upgrade_
- Swarm of insects that need to be chased away to let the vines grow
- Intro cinematics
### Won't Have
