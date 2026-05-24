float last_time = 0;
float ghost_measure = 0;
float ghost_interval = 5000;
int ghost_cnt = 0;

class Ghost{
    float x = random(-bar_width/2, bar_width/2);
    float y = -300;
    float speed;
    int radius;
    boolean vanished = false;

    Ghost(){
        int type = floor(random(3+1));
        if(type == 1){
            speed = 0.5;
            radius = 30;
        }

        if(type == 2){
            speed = 0.3;
            radius = 50;
        }

        if(type == 3){
            speed = 1.6;
            radius = 15;
        }
    }
}

Ghost[] ghosts = new Ghost[500];

void drawGhosts(){
    float elapsed_time = millis() - ghost_measure;
    if(elapsed_time >= ghost_interval){
        Ghost ghost = new Ghost();

        ghosts[ghost_cnt] = ghost;
        ghost_cnt++;
        ghost_measure = millis();
        ghost_interval = 5500 + random(1500);
    }

    for(int i=0; i<ghost_cnt; i++){
        if(ghosts[i].vanished) continue;

        float x = ghosts[i].x;
        float y = ghosts[i].y;
        float speed = ghosts[i].speed;
        float r = ghosts[i].radius;
        ellipse(x, y, r, r);
        ghosts[i].y += speed;

        if(y >= -bar_height + x*tan(angle)){
            ghosts[i].vanished = true;
            angle += radians(x*speed*r/120);
        }
    }
}