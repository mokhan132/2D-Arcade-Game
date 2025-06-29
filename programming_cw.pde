Player player;
// Load in images
PImage playerImage;
PImage obstacleImage;
PImage fastObstacleImage;
//Initialise arrays and vairables
ArrayList<Obstacle> obstacles;
ArrayList<FastObstacle> fastObstacles;
int spawnTimer = 0; 
boolean gameOver = false;
int lives = 3; 
float playerAngle = 0;

//flags to track movement
boolean moveUp = false, moveDown = false, moveLeft = false, moveRight = false;

void setup() {
    size(800, 600);
    player = new Player(width / 2, height / 2);
    obstacles = new ArrayList<Obstacle>();
    fastObstacles = new ArrayList<FastObstacle>();
    playerImage = loadImage("arrow.png");
    obstacleImage = loadImage("bomb.png");
    fastObstacleImage = loadImage("pixel_grenade.png");
}

void draw() {
 if (!gameOver) {
        background(200);
        player.display();
        displayLives();

        for (int i = obstacles.size() - 1; i >= 0; i--) {
            Obstacle obs = obstacles.get(i);
            obs.move();
            obs.display();
             if (dist(player.x, player.y, obs.x, obs.y) < 40) {
                lives--; //takes away 1 life
                obstacles.remove(i);
                checkGameOver(); // checks lives aren't 0
            }
        }

        for (int i = fastObstacles.size() - 1; i >= 0; i--) {
            FastObstacle fObs = fastObstacles.get(i);
            fObs.move();
            fObs.display();
             if (dist(player.x, player.y, fObs.x, fObs.y)< 40){
                lives--; //takes away 1 life
                fastObstacles.remove(i);
                checkGameOver();
            }
        }

    
    //obstacle spawning
    spawnTimer++;
    if (spawnTimer >= 45) {
        spawnObstacle(); // spawn a new obstacle
        spawnFastObstacle();
        spawnTimer = 0; // reset timer
    }

    //player movement
    Movement();
    } else {
        displayGameOverScreen();
    }
}


void displayGameOverScreen() {
    background(0); // Black background for game over
    fill(255, 0, 0);
    textAlign(CENTER, CENTER);
    textSize(60);
    text("GAME OVER!", width / 2, height / 2 - 50);
}

void displayLives() {
    fill(0);
    textAlign(LEFT, TOP);
    textSize(20);
    text("Lives:" + lives, 10, 10);
}

void checkGameOver() {
    if (lives <= 0) {
        gameOver = true;
    }
}




void spawnObstacle() {
    float x, y;
    float distance;
    
    //keeps trying till outside safe radius
    do {
        x = random(width);
        y = random(height);
        distance = dist(x, y, player.x, player.y);
    } while (distance < 300); // 
    float speedX = 1;
    float speedY = 1;
    obstacles.add(new Obstacle(x, y, speedX, speedY));
}

//same function as above
void spawnFastObstacle() {
    float x, y;
    float distance;
    
    do {
        x = random(width);
        y = random(height);
        distance = dist(x, y, player.x, player.y);
    } while (distance < 300); 

    float speedX = 2.5;
    float speedY = 2.5;
    fastObstacles.add(new FastObstacle(x, y, speedX, speedY));
}



void Movement() {
    float dx = 0;
    float dy = 0;
    float moveSpeed = 5;

    if (moveUp) dy = -moveSpeed;
    if (moveDown) dy = moveSpeed;
    if (moveLeft) dx = -moveSpeed;
    if (moveRight) dx = moveSpeed;
    
    moveObstacles(-dx, -dy);
}

void moveObstacles(float dx, float dy) {
    for (Obstacle obs : obstacles) {
        obs.x += dx;
        obs.y += dy;
    }
    for (FastObstacle fObs : fastObstacles) {
        fObs.x += dx;
        fObs.y += dy;
    }
}

//make sure only one key is pressed at a time and change arrow direction
void keyPressed() {
    if (keyCode == UP) {
        moveUp = true;
        playerAngle = -HALF_PI; // Face upward
        moveDown = moveLeft = moveRight = false;
    }
    if (keyCode == DOWN) {
        moveDown = true;
        playerAngle = HALF_PI; // Face downward
        moveUp = moveLeft = moveRight = false;
    }
    if (keyCode == LEFT) {
        moveLeft = true;
        playerAngle = PI; // Face left
        moveUp = moveDown = moveRight = false;
    }
    if (keyCode == RIGHT) {
        moveRight = true;
        playerAngle = 0; // Face right
        moveUp = moveDown = moveLeft = false;
    
        
    }
}

void keyReleased() {
    if (keyCode == UP) moveUp = false;
    if (keyCode == DOWN) moveDown = false;
    if (keyCode == LEFT) moveLeft = false;
    if (keyCode == RIGHT) moveRight = false;
}


class Player {
    float x, y;

    Player(float x, float y) {
        this.x = x;
        this.y = y;
    }

    void display() {
        pushMatrix();               
        translate(x, y);            // moves to the player's position
        rotate(playerAngle);        // rotates the arrow to the correct direction
        imageMode(CENTER);          
        image(playerImage, 0, 0, 50, 50); // draw new image of player
        popMatrix();                
    }
}

class Obstacle {
    float x, y, speedX, speedY;

    Obstacle(float x, float y, float speedX, float speedY) {
        this.x = x;
        this.y = y;
        this.speedX = speedX;
        this.speedY = speedY;
    }

    void move() {
        x += speedX;
        y += speedY;
        if (x < 0 || x > width) speedX *= -1;
        if (y < 0 || y > height) speedY *= -1;
    }

    void display() {
        imageMode(CENTER);
        image(obstacleImage, x, y, 40, 40); 
    }
}

class FastObstacle extends Obstacle {
    FastObstacle(float x, float y, float speedX, float speedY) {
        super(x, y, speedX, speedY);
    }

    void display() {
        imageMode(CENTER);
        image(fastObstacleImage, x, y, 30, 30); 
    }
} 
