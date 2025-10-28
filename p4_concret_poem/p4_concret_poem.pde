PFont myfont;
String o = "ja";  

ArrayList<JaLinea> lineas;

void setup() {
  size(595, 879); 
  myfont = createFont("B.S.-Mono-Regular.otf", 10);
  
  textAlign(CENTER, CENTER);
  background(255);
  frameRate(50);

  lineas = new ArrayList<JaLinea>();

  //  6 líneas diagonales 
  float[] alturas = {0.1, 0.25, 0.4, 0.55, 0.7, 0.85};
  for (float h : alturas) {
    lineas.add(new JaLinea(-100, height * h, 1, 1));
  }

  //  líneas verticales 
  float[] anchos = {0.1, 0.25, 0.4, 0.55, 0.7, 0.85};
  for (float w : anchos) {
    lineas.add(new JaLinea(width * w, -100, 0, 1));
  }
}

void draw() {
  background(255); //  limpiar fondo cada frame para que transparencia se vea bien
  for (JaLinea linea : lineas) {
    linea.update();
    linea.display();
  }
}


// Clase para una línea de "ja" dispersos

class JaLinea {
  ArrayList<PVector> posiciones;
  PVector direccion;
  float velocidad = 4;
  int maxSize = 300;
  int cadaCuantosFrames = 3;
  float minDist = 25; // distancia mínima entre "ja"

  JaLinea(float x, float y, float dx, float dy) {
    posiciones = new ArrayList<PVector>();
    direccion = new PVector(dx, dy);
    posiciones.add(new PVector(x, y));
  }

  void update() {
    if (frameCount % cadaCuantosFrames != 0) return;

    if (posiciones.size() < maxSize) {
      PVector ultima = posiciones.get(posiciones.size() - 1);
      PVector nueva;
      int intentos = 0;

      do {
        float ruidoX = random(-15, 15);
        float ruidoY = random(-15, 15);
        nueva = new PVector(
          ultima.x + direccion.x * velocidad + ruidoX,
          ultima.y + direccion.y * velocidad + ruidoY
        );
        intentos++;
      } while (!esValida(nueva) && intentos < 10);

      posiciones.add(nueva);
    }
  }

  boolean esValida(PVector p) {
    for (PVector q : posiciones) {
      if (dist(p.x, p.y, q.x, q.y) < minDist) return false;
    }
    return true;
  }

  void display() {
    noStroke();
    textSize(10);

    for (int i = 0; i < posiciones.size(); i++) {
      PVector p = posiciones.get(i);

      // Transparencia gradual 
      float alpha = map(i, 0, posiciones.size(), 50, 200); // de más transparente a más opaco
      fill(0, alpha);

      float separacion = 6;
      for (int j = 0; j < o.length(); j++) {
        char c = o.charAt(j);
        text(c, p.x + j * separacion, p.y + sin(j + frameCount * 0.05) * 2);
      }
    }
  }
}
