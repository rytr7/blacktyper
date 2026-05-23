JSONArray json;
JSONObject question;
String kanji; String roman;

float angle = 0;
float rotate_speed = 0.03;
float ball_x = 0;
float ball_y = 0;
float ball_speed = 0.0;
float gravity = 0.08;
float ball_r = 12.0;
float bar_width = 350.0;
float bar_height = 20.0;

int idx = 0;
int score = 0;

float last_time = 0;
float ghost_measure = 0;
float ghost_interval;
int ghost_cnt = 0;

class Ghost{
    float x, y;
    float speed;
    int radius;
    boolean vanished = false;
}

Ghost[] ghosts = new Ghost[500];

void setup() {
    size(800, 600);
    // textAlign(CENTER);

    json = loadJSONArray("questions.json");
    getProblem();
}

void keyPressed() {
    if(roman.charAt(idx) == key){
        idx++;
        if(idx == roman.length()){
            getProblem();
            score++;
        }
    }
}

void getProblem() {
    idx = 0;
    int rnd = floor(random(20));
    JSONObject question = json.getJSONObject(rnd);
    kanji = question.getString("kanji");
    roman = question.getString("roman");

    last_time = millis();
}

void draw() {
    translate(width/2, height/2+150);
    background(230, 180, 130);

    // problem
    fill(255, 255, 255);
    PFont font = createFont("Meiryo", 24);
    textFont(font);

    String left = roman.substring(0, idx);
    String right = roman.substring(idx);

    text(kanji, -300+0, -200);
    text(right, -300+textWidth(left), -170);
    fill(255, 0, 0);
    text(left, -300+0, -170);

    // タイマーの表示
    float remaining_time = 10000 - (millis() - last_time);

    rectMode(CORNER);
    rect(70, -350, remaining_time/10000*300, 40);
    rectMode(CENTER);

    // ゴースト
    double elapsed_time = millis() - ghost_measure;
    if(elapsed_time >= 5500){
        Ghost ghost = new Ghost();
        ghost.x = 100;
        ghost.y = -300;
        ghost.speed = 0.5;

        ghosts[ghost_cnt] = ghost;
        ghost_cnt++;
        ghost_measure = millis();
    }

    for(int i=0; i<ghost_cnt; i++){
        if(ghosts[i].vanished){
            println(ghosts[i].vanished);
            continue;
        }

        ellipse(ghosts[i].x, ghosts[i].y, 30, 30);
        ghosts[i].y += ghosts[i].speed;

        if(ghosts[i].y >= -bar_height + 100*tan(angle)){
            ghosts[i].vanished = true;
            angle -= radians(20);
        }
    }

    // 棒
    if(abs(ball_x) <= bar_width / 2 && remaining_time > 0){
        if (mousePressed) {
            if (mouseButton == LEFT)  angle -= rotate_speed;
            if (mouseButton == RIGHT) angle += rotate_speed;
        }

        float acceleration = gravity * sin(angle);
        
        ball_speed += acceleration;
        ball_speed *= 0.98;
        ball_x += ball_speed;

        pushMatrix();
        rotate(angle);
        fill(50, 100, 200);
        noStroke();
        rect(0, 0, bar_width, bar_height);
        ball_y = -(bar_height/2 + ball_r);
        fill(230, 80, 80);
        ellipse(ball_x, ball_y, ball_r * 2, ball_r * 2);
        popMatrix();

    } else {
        // GAME OVER
        fill(230, 80, 80);
        ball_y += 1.8;
        ellipse(ball_x, ball_y, ball_r * 2, ball_r * 2);
    }
}