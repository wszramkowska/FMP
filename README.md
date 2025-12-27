# FMP

Wiktoria Szramkowska

2106125



I really enjoy indie horror and a first person horror game was an obvious choice for my FMP, I have been building the skills I need for this project during the last 2 years of my Games Development course. There is a lot of different directions to go when it comes to indie horror, but I have a few ideas I am keen on implementing such as, a focus on atmospheric horror and an enemy AI which seems to behave intelligently. I first want to do some research to be better informed on what I really want to do with my game and the key mechanics I want to implement. 

## Research




I wanted to look at some video games to get inspiration for my game, specifically horror games that have one "big bad" enemy. Some games that come to mind included Alien: Isolation (Creative Assembly, 2014) and Amnesia: The Bunker (Frictional Games, 2023)
I will of course also be looking at Unreal documentation throughout my project, when I feel stuck with blueprints or anything else, as documentation is a good, official and up to date source.
For my core mechanics I will try to find video tutorials to help me.

#### Sources

#### Alien: Isolation

Alien: Isolation is a survival horror game published in 2014 and developed by Creative Assembly. I chose this game because of the anatagonist, the Xenomorph, which remains a benchmark in AI design over a decade later. The developers are able to create the illusion of an intellifent enemy that learns from the player through clever use of complex behaviour trees and a two tier system for the AI (aetos, 2025). I want to use what I have learned to create my own complex enemy that appears to learn from and adapt to the player. 

[How Does The Alien Work Off Camera Alien Isolation](https://youtu.be/MNMAduVsqhQ?si=Xm99RoZNNz3GOLOj)

<iframe width="560" height="315" src="https://www.youtube.com/embed/MNMAduVsqhQ?si=Xm99RoZNNz3GOLOj" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>


<br>


#### Unreal Documentation

Another source I will be regularly going to throughout my project is the Unreal Documentation as I believe it has some of the most accurate and up to date information. There are multiple that I will be using depending on the specific mechanics I am trying to implement, one such documentation is the AI Perception system (AI Perception in Unreal Engine | Unreal Engine 5.5 Documentation | Epic Developer Community, s.d.) which I used to help create my enemy AI.

Specifically I looked at AI Hearing and AI Sight. Hearing is handled by calling a 'Report Noise Event' which simulates the NPC hearing a sound. Sight alerts the NPC when player or an object enters the sight radius. 

I will also be using Behaviour Trees to manage the behaviour of my enemy AI. Although I have made games in Unreal Engine before, I actually have not used Behaviour Trees before so I will be frequently referring to documentation.

I started with learning the basics by reading the Quick Start Guide. (Behavior Tree in Unreal Engine - Quick Start Guide | Unreal Engine 5.7 Documentation | Epic Developer Community, s.d.) which explains how to create an enemy AI in Unreal Engine that patrols the level, detects the player using AI Perception, and switches to chasing them when they are seen. It covers setting up an AI Controller, Blackboard, and Behavior Tree with tasks for patrolling and chasing, using decorators to control state changes based on line of sight. When the AI loses sight of the player for a set time, it stops chasing and returns to patrolling, demonstrating a complete, reactive AI loop built with Blueprints.

Overall I think documentation is incredibly useful and as it is written on the official site, the information is incredibly accurate and is updated frequently. 

<br>

#### A survey of Behavior Trees in robotics and AI

I looked at academic papers, specifically about Behaviour trees to understand the underlying structure, strengths and limitations of Behaviour Trees. *A Survey of Behavior Trees in Robotics and AI* provided me with a strong academic foundation on understanding Behaviour Trees beyond engine-specific tutorials. The paper covers behavior tree theory, comparisons with other AI approaches such as finite state machines, and practical applications, making it particularly valuable for implementing complex AI behaviour correctly (Iovino et al., 2022). 

The source is reliable because it is written by established researchers and based on peer-reviewed academic work, providing a strong theoretical foundation for behaviour trees that are still widely used in Unreal Engine. However, it may be slightly outdated, as it does not cover recent engine-specific features or workflows, reflecting how quickly game technology evolves.





## Implementation




#### Planning 

My first goal is to make a prototype which can prove my game idea will work and is executable. I set out a few simple goals to achieve in this stage including a simplified version of the final AI (detects sound, sees player, chases player, patrols), and a working light system. These cover the core mechanics in my game. Other features such as player health and damage, crouching and sprinting, I have already done in previous projects so I am confident I will be able to implement them. 

#### Health and Damage System 


<br>

#### Enemy AI 

My enemy will be 


<br>
 
#### Enemy Animations
To animate my enemy I used animations from Mixamo. I used a combination of animation blueprints, blend spaces and animation montages. So far in my project I had a good understanding of what was going on but I really struggled with animations. To help I went over my Animation System task journal so I could figure out idle, walk and run animations. I also found a youtube video by Lisowi (AI Attack Tutorial - Unreal Engine 5.2, 2023) which showed me how to play my attack animations once the enemy is in attack range of the player.

- I made a blend space for my zombie character. This would transition between the idle, walking and run animation. 
- I used this blend space in an animation blueprint. This would change the animation based on the speed of the enemy, so during chases it would play the running animation.

<iframe src="https://blueprintue.com/render/uk4uthg-/" scrolling="no" allowfullscreen></iframe>

*Figure 7. Animation blueprint event graph*


- I created an attack animation montage for my enemy, in case I wanted a variety of animations for the attack.
- I added a montage notify in my zombie attack montage. This is timed to be where the enemies hand begins to come down, as that is where the player appears to be taking damage.
- In my enemy blueprints I played the animation montage when the player was within attack range. 

<iframe src="https://blueprintue.com/render/muk6va19/" scrolling="no" allowfullscreen></iframe>

*Figure 8. Blueprints for enemy attack animation*

[Enemy animation](https://www.youtube.com/watch?v=Di2K0OgP76Q&ab_channel=WSzramkowska)

<iframe width="560" height="315" src="https://www.youtube.com/embed/Di2K0OgP76Q?si=MK6J8ufW9gO_DBI5" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>


<br>

#### Building the map
I looked through the asset packs on Fab and found a medieval dungeon asset pack by Infuse Studio which I thought would be perfect to help create an unsettling atmosphere in my game.

- Small map to get the feeling of being trapped with the enemy.
- Lots of 'rooms' for the player to explore the environment, and also to disorient the player, making it a bit more difficult to search for the exit.
- The rooms gave me the idea to include a key the player would have to search for in order to unlock the exit. The key would force the player to move around the map more, which increases the likelihood of them encountering the enemy.
- Slight variation in shape but the map is mostly just a rectangle, with more rectangles inside. This keeps it clean and fair. 
- Since I decided to keep the map small I thought my game would work well with just the one enemy. This is when I had the idea to make the enemy a one shot kill on the player, which would add to the tension. This also meant I would no longer need the HP bar I made at the beginning of the project.
- I did some scene dressing, adding in props to make the environment feel more alive and in general be less boring to look at. I tried to vary the rooms, but not have too many props so as not to distract too much from looking for the key.

<br>

#### Interact: Key and door
Since I had the idea to add a key into the game, I decided to work on it right away. I found a video tutorial by Matt Aspland (Door And Key System | How To Open A Locked Door With A Key In Unreal Engine 5 (Tutorial), 2023) on making a door and key system. This taught me how to create an interact input, how to animate my door using a timeline, and how to specify which key unlocks which door.

- Made a blueprint interface for 'interact' and 'door'
- Set 'E' as my interaction button and added the interact input logic to my third person character blueprint. I used the enhanced input action system.
- Made a blueprint for key and door. Gave them both collision boxes.
- Animated the door using a timeline

<iframe src="https://blueprintue.com/render/qxpkc30l/" scrolling="no" allowfullscreen></iframe>

*Figure 9. Blueprints for the Interact Input*

- Door opens if 'HasKey?' is true
- Left and right door are animated using set relative rotation and door timeline

<iframe src="https://blueprintue.com/render/msw381ik/" scrolling="no" allowfullscreen></iframe>

*Figure 10. Blueprints for door opening*

- When player picks up key, the key object is destroyed

<iframe src="https://blueprintue.com/render/a1s2vpwl/" scrolling="no" allowfullscreen></iframe>

*Figure 11. Blueprints for destroying the key*

[Key and door test](https://www.youtube.com/watch?v=WYU4weehMSc&ab_channel=WSzramkowska)

<iframe width="560" height="315" src="https://www.youtube.com/embed/WYU4weehMSc?si=BMbtg7huz3RYLgm7" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>


#### Lighting 
For lighting I knew I wanted my level to be fairly dark in order to create a scary atmosphere, hiding my enemy in the shadows. As I have never done this before I searched for a youtube video which could show me some of the possibilities with lighting in Unreal. I found one by Matt Aspland which specifically looks at interiors (How To Light Interiors In Unreal Engine 4 & 5 (Tutorial), 2022).

- I used torches to light up the corridors, using a fire particle asset I created in one of my earlier tasks. 
- I used rect lights in the rooms as the player would have to search for the key in these so I thought it would be fair to make them brighter.
- I used point lights on some of the torches to give a brighter orange glow in the area, replicating the sort of lighting you get from fire.

[Lighting Test](https://www.youtube.com/watch?v=qyXZ1G6vcNA&ab_channel=WSzramkowska)

<iframe width="560" height="315" src="https://www.youtube.com/embed/qyXZ1G6vcNA?si=f1LQDMbGgLZZHKGA" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

#### Visual Improvements

- Changed my third person camera to first person by moving the camera attached to my character into the head. First person made the game much scarier as you could no longer see what was happening behind you or to the side of you.
- Adding vignette for a horror feel.
- Decreasing field of view, meaning the player sees less and the enemy is scarier.
- Increased intensity of fog to add to the creepy atmosphere.

#### Audio 
Audio is a key feature in horror games and can really set the tone and mood of the game. I got my sounds and music from Zapsplat and Pixabay.

- I used meta sound source for audio 
- Most of my sounds are set up quite basic escept breathing which has a filter and limiter as it was originally too loud and obnoxious.

<iframe src="https://blueprintue.com/render/kdmyjw2m/" scrolling="no" allowfullscreen></iframe>

*Figure 12. Meta sound source for human breathing*

- I created sound attenuation for fire, to add a bit of liveliness to the environment.
- I created sound attenuation for the zombie footsteps so the player can only hear them when they are close by.
- Footstep sounds were done by adding a 'play sound' notify to the zombie walk and run animations. I timed these notifies with when the zombies foot was on the ground. This allowed me to achieve footsteps which matched the visual and the sound.
- I also added sound attenuation to zombie breathing so the player starts hearing these disturbing noises when the enemy is nearby.

Background sound to make the environment feel alive:
- Horror music
- Dungeon ambience

Sounds:
- Footsteps - help the player avoid the enemy but also build tension as you know he is near
- Zombie breathing/noises - unsettling almost choking sounds which convey your enemy is a monster and not something human
- Human/player breathing: Faint breathing, people often breathe heavier when experiencing anxiety or fear
- Zombie scream - lets the player know the enemy is directly behind them and attacking

#### Menus 
Now that my main game loop was done I needed to create some menus so the player could navigate the game and there was on obvious win/lose. Although I have done a widget for my health bar early on in my project, I still wasn't the most familiar with UI in Unreal and its capabilities. To learn more about it I watched a video by Unreal University which showed how to create a main menu (How To Create A Main Menu - Unreal Engine 5 Tutorial, 2022). This video helped me learn how to use buttons which turned out to be fairly simple with the 'on clicked' events. I focused on functionality rather than visuals as I wanted feedback on my main gameplay loop.

Main menu 
- Used a screenshot of my game as a background image
- Start and quit buttons 
- Title of my game 
- Tried to pick a horror font but I did not spend too much time on this as it is not the focus for my project or developing my skills.

<iframe src="https://blueprintue.com/render/2iq9qb9i/" scrolling="no" allowfullscreen></iframe>

*Figure 13. setting input mode blueprints*

<iframe src="https://blueprintue.com/render/xtx_purr/" scrolling="no" allowfullscreen></iframe>

*Figure 14. blueprints for start and quit button*

Game win
- Button to main menu restart or quit
- Simple Escaped message 

<iframe src="https://blueprintue.com/render/in6q22_q/" scrolling="no" allowfullscreen></iframe>

*Figure 15. blueprints for game win*

Game Loss
- Button to main menu, restart or quit
- Simple game over message

<iframe src="https://blueprintue.com/render/4285lcww/" scrolling="no" allowfullscreen></iframe>

*Figure 16. blueprints for game over*

[Menus Test](https://www.youtube.com/watch?v=yQ6JdHc166k&ab_channel=WSzramkowska)

<iframe width="560" height="315" src="https://www.youtube.com/embed/yQ6JdHc166k?si=YFVE2nFVEi45mkz4" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

#### Feedback
I asked family, friends and colleagues to test out my game and give me their feedback. 

Key points from feedback:
- Game is scary, when the enemy is near there is a good level of tension
- Enemy ai could be more advanced e.g. the enemy can hear the player
- Lighting looks good and effective for the genre
- Once you find the key and escape, there is not much incentive to play again as you know where the key is so the game feels easier
- Map is good, not too big but still able to get away from the enemy
- Menus could look more interesting
- There are no instructions for what to do or how to play 

At this point I had limited time left to polish my project so I picked a couple points that I thought were very important and would greatly improve my game, but were still doable within the remaining time frame.

"No incentive to replay"
I wanted my game to be enjoyable for multiple runs and not just a one shot as that might mean the player doesn't even see the entire environment or potentially might not even meet the enemy if very lucky. To solve this issue I decided I would spawn my key in a random location from a set of predetermined locations. This means finding the key is not enough, you actually have to escape as well because on your next run it might be in a different location. It also encourages exploration.

"No instructions"
I think players can get easily frustrated when the objective of the game is not clear. I do not want players to get discouraged and drop my game so I decided to add a simple quest style bar in the top right which would direct the player. In addition I would add a message to the door saying something like "Press E to open" to make the controls of the game more obvious.

#### Randomly Spawning Key
I found a video by RubaDev on how to randomize actor spawn locations and adapted this to my blueprints in order to get different spawn locations for my key each time the level starts. 

- Set 5 target points where I wanted my key to spawn. I didn't want completely random spawn points as I wanted the locaction of the key to be fair and to make sense within the environment.
- Referenced these target points in my level blueprint and put them in an array.
- Got the locations and randomised them using 'random integer in range'
- Spawned the key

<iframe src="https://blueprintue.com/render/gfmawe9q/" scrolling="no" allowfullscreen></iframe>

*Figure 17. blueprints for spawning key in random locations*

#### 'Quest' bar
- I created a widget with a small quest bar in the top right of the screen. I added this to viewport from the BP_Key blueprint.
- Initially set to 'find the key'
- Upon player picking up the key I set the text to 'Escape' 

<iframe src="https://blueprintue.com/render/nc8-esjh/" scrolling="no" allowfullscreen></iframe>

*Figure 18. blueprints for adding the quest bar to viewport and setting the text after picking up ley*

#### Press 'E' prompt on door
- I made a widget and attached it to my door blueprint
- I made the widget visible when the player was within the doors collision box.

<iframe src="https://blueprintue.com/render/kk4k8d5g/" scrolling="no" allowfullscreen></iframe>

*Figure 19. blueprints for interaction prompt*

<br>

### Did you have any technical difficulties? If so, what were they and did you manage to overcome them?

- Did you have any issues completing the task? How did you overcome them?

##### Door
- opened too quick so I used a lerp node instead of setting my rotation inside of my door timeline 
- only set relative rotation
- doors were opening the opposite way so I added a multiply by -1 to the right door

##### Interact prompt
- was too low down and player couldn't see it so i changed the 'space' to world instead of screen as my message doesnt need to appear in a 360 around the door
- text was always shown so i had to set the initial visibility to off

##### Enemy sounds
- footsteps did not work
- fixed them by adding the play sound to my enemy walking and running animation, playing the sound when the foot was down
- zombie breathing didn't work unless the player spawned within its radius, and wouldnt restart if the player left and returned to the radius
- fixed this by checking play when silent

##### Github
- I had multiple difficulties with using github. Although I have used it for my previous tasks, this unit is the first time I have used github.
- When I downloaded my Medieval Dungeon Asset Pack I was unable to commit and push my changes. To fix this I downloaded git LFS. However that still did not work so I ended up deleting assets I did not need so I was able to commit and push.
- Despite having a .gitignore, whenever I made a build I could not commit my changes in github. I created a folder outside of the github repository, on my desktop, to fix this. However this still did not work so I had to manually delete the build folders within my repository. I also had to discard changes in the commit that were over 100mb, despite having git lfs set up.
- In future projects I will set up git lfs at the start and will also double check my .gitignore is set up correctly. This will hopefully prevent these problems from happening.


## Outcome





## Critical Reflection







## Bibliography

aetos (2025) The Illusion of Intelligence: A Technical Breakdown of Alien: Isolation’s AI. At: https://medium.com/@aetosdios27/the-illusion-of-intelligence-a-technical-breakdown-of-alien-isolations-ai-b2d7c9927d02 (Accessed  11/12/2025).

How Does The Alien Work Off Camera Alien Isolation (2023) Directed by Slippy Slides. At: https://www.youtube.com/watch?v=MNMAduVsqhQ (Accessed  11/12/2025).

Thompson, T. (2025) Revisiting the AI of Alien: Isolation. At: https://www.aiandgames.com/p/revisiting-alien-isolation (Accessed  11/12/2025).

Alien: Isolation - The Retrospective | AI and Games (2025) Directed by AI and Games. At: https://www.youtube.com/watch?v=LeIkEoHglQQ (Accessed  11/12/2025).

Behavior Tree in Unreal Engine - Quick Start Guide | Unreal Engine 5.7 Documentation | Epic Developer Community (s.d.) At: https://dev.epicgames.com/documentation/en-us/unreal-engine/behavior-tree-in-unreal-engine---quick-start-guide (Accessed  27/12/2025).

Iovino, M., Scukins, E., Styrud, J., Ögren, P. and Smith, C. (2022) 'A survey of Behavior Trees in robotics and AI' In: Robotics and Autonomous Systems 154 p.104096.





## Declared Assets


Used to assist in finding and summarising research material:
Chat GPT
