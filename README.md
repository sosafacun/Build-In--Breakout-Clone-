# Buildin (Breakout Clone)

Second challenge of the [20 game challenge](https://20_games_challenge.gitlab.io/).

Game #2-a

> Atari’s first successful game (Pong) was massively successful, but many companies made clones of the game, which eroded Atari’s profits. Their response was to make new and innovative games in order to stay ahead of the competition. Breakout was a direct descendent of Pong, but was designed for one player instead of two. It came out in 1976.
> 
> Fun fact: Steve Jobs and Steve Wozniak (yes, the Apple guys) worked together to design the Breakout hardware. Like Pong, the game was made from transistors. Again, the game will be much easier to make if you use a modern game engine instead of starting from a pile of wires.

**Note**: I'll be making my own assets using [Krita](https://krita.org/) for the graphics and [beepbox](https://www.beepbox.co) for the sounds / music.

# Done:

**Goals:**
- Create a game space with walls and a ceiling.
- Add a paddle that can be moved left and right via player inputs.
- Add a ball that will bounce off of the paddle, walls, and ceiling.
- Add square game objects (bricks) into the top of the game space. (The original game had eight rows of 16 bricks each, though you can change the number of bricks depending on the size of the game space)
- Enable the ball to bounce off of the bricks. When the ball bounces, the brick should disappear. 
- Breaking a brick should add to the player’s score.
- The ball’s speed should increase as bricks are broken.
- The score should be displayed, as well as a life counter. The player starts with three lives. If the player misses the ball, a life should be subtracted. 
- When all lives are used, the game ends.

**Stretch Goals:**

- Add different colors to the bricks in the rows. (The original game was black-and-white, but had a colored film on the screen, simulating colored rows of bricks)

**Personal Goals:**

- Introduced a toggable colorblind mode


# TODO:

**Goals:**


**Stretch Goals:**

- Save the high score between play sessions and display it alongside the player score.

**Personal Goals:**

- Static type **everything** and don't let residual code lingering.
- Create (at least) 10 lvls
- Add power ups that affect the game. They should be dropped upen breaking a brick. Some examples: 1UP, Widder Paddle, Faster and stronger ball, Multiple balls
