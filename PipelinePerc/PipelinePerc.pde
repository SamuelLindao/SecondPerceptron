PImage img; //<>//
PImage imgP;
PImage imgN;
ArrayList<String> imgs = new ArrayList<String>();
int maxImages = 6;
int currentIndex = 0;
int Perc = 0;

class RGB {
  int r;
  int g;
  int b;
  int c;

  RGB(int r, int g, int b, int c) {
    this.r = r;
    this.g = g;
    this.b = b;
    this.c = c;
  }
}

ArrayList<RGB> colors = new ArrayList<RGB>();

void loadImages(String folderPath) {
  File folder = new File(dataPath(folderPath));
  File[] files = folder.listFiles();
  
  for (File file : files) {
    if (file.isFile() && (file.getName().endsWith(".png") || file.getName().endsWith(".jpg") || file.getName().endsWith(".jpeg"))) {
       imgs.add(folderPath + "/" + file.getName());
       println(folderPath + "/" + file.getName());
    }
  }
}

void setup() {
  size(1200, 320);

  loadImages(sketchPath() + "/Imagens");
  img = loadImage("img.png");

  color c;
  float r = 0, g = 0, b = 0;
  int contp = 0;
  int contn = 0;
  int margin = 250;


//Amostras
  for (int i = 0; i < img.height; i++) {
    for (int j = 0; j < img.width; j++) {
      c = img.get(i, j);
      r = red(c);
      g = green(c);
      b = blue(c);
      
      float z = abs(j - img.width / 2) / (img.width / 2.0);

      if (j < margin || j >= img.width - margin) {
        contn++;
        colors.add(new RGB((int) j, (int) i, (int) z, -1));
      } else {
        contp++;
        colors.add(new RGB((int) j, (int) i, (int) z, +1));
      }
    }
  }
  
  println("contn : " + contn);
  println("contp : " + contp);

  // Treinamento do perceptron
  float x = 0.0f, y = 0.0f,z=0.0f, bias = 0.0f;
float w1 = random(-0.1f, 0.1f);
float w2 = random(-0.1f, 0.1f);
float w3 = random(-0.1f, 0.1f);
  float s = 0.0f;
  int classV = 0;
  int epocas = 100;
  int count = 0;
  float TA = 0.001f;
  float erro = 0, desejado = 0, saida = 0;

  while (count < epocas) {
    for (int i = 0; i < colors.size(); i++) {
      x = colors.get(i).r;
      y = colors.get(i).g;
      z = colors.get(i).b;  
      classV = colors.get(i).c;

      if (classV == -1)
        img.set((int) x, (int) y, color(255, 0, 0));

      if (x <= margin + 200 || x >= img.width - margin - 200) {
        desejado = classV;

       s = (w1 * x) + (w2 * y) + (w3 * z) + bias;
        
        saida = s > 0 ? 1 : -1;
        
        erro = desejado - saida;
        
        if (erro != 0) {
          w1 = w1 + TA * erro * x;
          w2 = w2 + TA * erro * y;
          w3 = w3 + TA * erro * z;
          bias = bias + TA * erro;
        }
      }
    }
    count++;
  }

  img.save(sketchPath() + "/Resultados/Debug" + currentIndex + ".png");
  println("w1: " + w1 + " w2: " + w2 + " w3: " + w3);
  println("Treinamento concluído.");


//Classificação
  int counnt = 0;
  while (currentIndex < maxImages) {
    String h = imgs.get(currentIndex);
    img = loadImage(h);
    imgP = loadImage(h);
    imgN = loadImage(h);
    for (int i = 0; i < img.height; i++) {
      for (int j = 0; j < img.width; j++) {

 z = abs(j - img.width / 2) ;
float newS = (w3 * z) + 85000;
        if (newS > 0) {
          imgP.set(j, i, color(255, 255, 255));
        } else {
          counnt++;
          imgN.set(j, i, color(255, 255, 255));
        }
      }
    }

    String fileNameA = sketchPath() + "/Resultados/finalImageN" + currentIndex + ".png";
    imgN.save(fileNameA);
    currentIndex++;
  }
  exit();
}
``
