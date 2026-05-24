JSONArray json;
JSONObject question;
String kanji; String roman;

int scene = 0;

float angle = 0;
float rotate_speed = 0.03;
float paper_x = 0;
float paper_y = 0;
float paper_speed = 0;
float gravity = 0.08;
float bar_width = 350;
float bar_height = 20;

int idx = 0;
int score = 0;

class Paper{
    float width = 50;
    float height = 80;
}

void drawPaper(Paper p){
    pushMatrix();
    rectMode(CORNERS);
    fill(230);
    float theta = radians(80);
    float COS = cos(theta);
    float SIN = sin(theta);
    float eps = -bar_height/2;
    float w = p.width;
    float h = p.height;

    ellipse(paper_x, eps, 7, 7);

    stroke(10);
    for(int i=0; i<score+1; i++){
        quad(paper_x, eps, -w*COS+paper_x, -w*SIN+eps, h*SIN-w*COS+paper_x, -h*COS-w*SIN+eps, h*SIN+paper_x, -h*COS+eps);
        eps -= 8;
    }

    fill(0);
    // 線

    popMatrix();
}

void setup() {
    size(800, 450);

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

int sx1, sy1, sx2, sy2;
void mouseClicked(){
    int mx = mouseX - width/2;
    int my = mouseY - height/2;
    if(sx1 <= mx && mx <= sx2 && sy1 <= my && my <= sy2){
        println("ok");
        scene = 1;
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
    background(5, 5, 30);

    if(scene == 0){
        translate(width/2, height/2);
        PFont title = createFont("HGGyoshotai", 35);
        textFont(title);

        textAlign(CENTER);
        fill(255);
        text("ブラックタイパー", 0, -150);

        sx1 = -70;
        sy1 = 50;
        sx2 = 70;
        sy2 = 95;

        rectMode(CORNERS);
        rect(sx1, sy1, sx2, sy2);
        PFont btn = createFont("HGGyoshotai", 20);
        textFont(btn);
        fill(0);
        text("プレイ", 0, (sy1+sy2)/2);

    } else if(scene == 1){
        translate(width/2, height/2+150);

        // problem
        fill(255);
        PFont font = createFont("Meiryo", 24);
        textFont(font);

        String left = roman.substring(0, idx);
        String right = roman.substring(idx);

        text(kanji, -300+0, -200);
        text(right, -300+textWidth(left), -170);
        fill(90, 90, 90);
        text(left, -300+0, -170);

        // タイマーの表示
        float remaining_time = 10000 - (millis() - last_time);

        rectMode(CORNER);
        rect(70, -350, remaining_time/10000*300, 40);
        rectMode(CENTER);

        drawGhosts();

        // 机
        if (mousePressed) {
            if (mouseButton == LEFT)  angle -= rotate_speed;
            if (mouseButton == RIGHT) angle += rotate_speed;
        }

        float acceleration = gravity * sin(angle);
        
        paper_speed += acceleration;
        paper_speed *= 0.98;
        paper_x += paper_speed;

        pushMatrix();
        rotate(angle);
        fill(105, 75, 25);
        noStroke();
        rect(0, 0, bar_width, bar_height);
        fill(230, 80, 80);

        Paper paper = new Paper();
        drawPaper(paper);
        popMatrix();

    } else{

    }
}