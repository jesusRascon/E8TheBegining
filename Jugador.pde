class Jugador extends Personaje {
  float preVelY;
  int ALTO_ATAQUE = int(sprites[RIGHT][0].height * wRatio + 10);
  int ANCHO_ATAQUE = int(100 * wRatio);
  int NUM_SPRITES_ATTACK = 11;
  float currentFrameAttack;
  int puntuacion;
  int carga;
  int cargaMax;

  PImage[] attack;

  Jugador(Vec2 center, String spriteDirectory, int numSpr, int numSts, boolean flotante) {
    super(center, spriteDirectory, numSpr, numSts, flotante);
    preVelY = body.getLinearVelocity().y;
    vidaActual = 100;
    vidaMax = vidaActual;
    carga = 100;
    cargaMax = carga;
    puntuacion = 0;

    currentFrameAttack = 0;

    attack = new PImage[NUM_SPRITES_ATTACK];
    for (int i = 0; i < attack.length; i++) {
      attack[i] = loadImage("media/jugador/attack/spr"+(i+1)+".png");
      attack[i].resize(int(attack[i].width * wRatio) + ANCHO_ATAQUE, int(attack[i].height * wRatio) + ALTO_ATAQUE);
    }
  }

  void accion() {
    mover();
    jump();
    shoot();
  }

  void mover() {
    Vec2 vel = body.getLinearVelocity();

    if (keyPressed) {
      if (keys['a'] || keys[LEFT_ARROW]) {
        state = State.left;
      }
      if (keys['d'] || keys[RIGHT_ARROW]) {
        state = State.right;
      }
    } else {      
      state = State.stop;
    }

    switch(state) {
    case left:
      vel.x -= 10 * wRatio;
      inMotion = true;
      currentDirection = LEFT;
      break;
    case right:
      vel.x += 10 * wRatio;
      inMotion = true;
      currentDirection = RIGHT;
      break;
    case stop:
      vel.x *= 0.69 * wRatio;
      break;
    }

    body.setLinearVelocity(vel);
  }

  void jump() {
    Vec2 vel = body.getLinearVelocity();


    //float diff =  vel.y - preVelY;

    // if (abs(diff)>3) {
    //   onAir=true;
    // } else onAir = false;

    //Si se pulsa space y no estamos en el aire, saltamos
    if ((keys[' '] || keys[UP_ARROW] || keys['w']) && !onAir) {
      jump.play();
      //estamos en el aire
      onAir=true;
      keys[32]=false; //Si lo descomentamos habrá que pulsar espacio cada vez que queramos saltar
      vel.y += 500 * wRatio * wRatio;
      body.applyLinearImpulse(vel, body.getWorldCenter(), true);
    }

    preVelY = body.getLinearVelocity().y;
  }

  void shoot() {
    if (keys['.'] && frameCount%10 == 0) {
      shoot.play();
      Vec2 pos = box2d.getBodyPixelCoord(this.body);
      float sprWidth = sprites[0][0].width;

      if (currentDirection == LEFT) {
        pos.x -= sprWidth/2+10;
        projectiles.add(new Bullet(pos, new Vec2(-10, 0), "jugador"));
      } else {
        pos.x += sprWidth/2+10;
        projectiles.add(new Bullet(pos, new Vec2(10, 0), "jugador"));
      }
    }
  }

  void atacar(ArrayList<Enemigo> enemigos) {

    if (keys[',']) {
      if (carga <= 0) {
        if (frameCount % 10 == 0)
          outOfAmmo.play();
      } else {
        carga--;
        attackAnimation();
        if (!meleeAttack.isPlaying())
          meleeAttack.play();
        Vec2 pos = box2d.getBodyPixelCoord(this.body);
        for (int i=0; i<enemigos.size(); i++) {
          Vec2 posEnemy = box2d.getBodyPixelCoord(enemigos.get(i).body);
          float x1 = pos.x-ANCHO_ATAQUE/2;
          float x2 = pos.x+ANCHO_ATAQUE/2;
          float y1 = pos.y-ALTO_ATAQUE/2;
          float y2 = pos.y+ALTO_ATAQUE/2;
          float anchoEnemigo = enemigos.get(i).sprites[RIGHT][0].width/2;
          float altoEnemigo = enemigos.get(i).sprites[RIGHT][0].height/2;
          if (((posEnemy.y + altoEnemigo >= y1) && (posEnemy.y - altoEnemigo <= y2))||
            ((posEnemy.y - altoEnemigo <= y2) && (posEnemy.y - altoEnemigo >= y1))) {
            if ((posEnemy.x - anchoEnemigo <= x2) && (posEnemy.x + anchoEnemigo >= x1)) {
              enemigos.get(i).recibirGolpe(LEFT, 10);
            }
            if ((posEnemy.x - anchoEnemigo <= x2) && (posEnemy.x + anchoEnemigo >= x1)) {
              enemigos.get(i).recibirGolpe(RIGHT, 10);
            }
          }
        }
      }
    } else {
      meleeAttack.stop();
    }
  }

  void attackAnimation() {
    Vec2 pos = box2d.getBodyPixelCoord(this.body);

    image(attack[int(currentFrameAttack+=0.5)%NUM_SPRITES_ATTACK], pos.x, pos.y);
  }

  void incrementCoins(int coins) {
    puntuacion += coins;
  }

  int getCoins() {
    return puntuacion;
  }

  void recargar(int valor) {
    carga = cargaMax;
    if(vidaActual + valor <= vidaMax){
      vidaActual += valor;
    } else vidaActual = vidaMax;
  }
}
