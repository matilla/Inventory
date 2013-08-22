class UIControl  //controls the User Interface. Everything is encapsulated here. Should implement an interface!
{
  private ControlP5 cp5;
  private InventorySkeleton system;
  private ButtonMatrix bm;
  private int buttonMatrixValue = 2;  //asign value 2 to all buttons in buttonmatrix
  private Product currentProduct;
  private Textfield searchName;
  private Button createProduct, showName, modifyProduct, deleteProduct;
  private Textarea info;
  private boolean modifyingInfo = false;
  private boolean buttonMatrixVisible = false;
  public UIControl(PApplet app, InventorySkeleton system)
  {
    cp5 = new ControlP5(app);
    this.system = system;
    initUI();
  }
  private int w(float coeff){return int(coeff*width);}
  private int h(float coeff){return int(coeff*height);}
  private void initUI()
  {
    float searchnamex = .2, searchnamey = .05, searchnamew = .3, searchnameh = .05;
    float createx = searchnamex + searchnamew + 0.1/*margin*/, createy = searchnamey, createw = searchnamew/2, createh = searchnameh;
    float areax = .05, areay = .5, areaw = .9, areah = .4;
    float matrixx = .01, matrixy = .2, matrixcm = .01, matrixrm = .01, matrixw = .3, matrixh = .05;
    float deletew = .15, deleteh = .025, deletex = areax+areaw-deletew, deletey = areay+areah;
    float modifyw = deletew, modifyh = deleteh, modifyx = areax+areaw-modifyw-deletew-.005/*margin*/, modifyy = areay+areah;
    float shownamew = deletew, shownameh = deleteh, shownamex = areax, shownamey = areay-shownameh;

    int snx = w(searchnamex), sny = h(searchnamey), snw = w(searchnamew), snh = h(searchnameh);
    int cx = w(createx), cy = h(createy), cw = w(createw), ch = h(createh);
    int ax = w(areax), ay = h(areay), aw = w(areaw), ah = h(areah);
    int mx = w(matrixx), my = h(matrixy), mcm = w(matrixcm), mrm = h(matrixrm), mw = w(matrixw), mh = h(matrixh), mc = int(width/(mcm+mw));
    int dx = w(deletex), dy = h(deletey), dw = w(deletew), dh = h(deleteh);
    int modx = w(modifyx), mody = h(modifyy), modw = w(modifyw), modh = h(modifyh);
    int shx = w(shownamex), shy = h(shownamey), shw = w(shownamew), shh = h(shownameh);
    
    
    
    PFont font = createFont("calibri", 20);

    searchName = cp5.addTextfield("searchName")
      .setPosition(snx, sny)
        .setSize(snw, snh)
          .setFont(font)
            .setAutoClear(false)
              .setFocus(true)
                .setCaptionLabel("SEARCH NAME")
                  .setColorCaptionLabel(0)
                    ;

    info = cp5.addTextarea("info")
      .setPosition(ax, ay)
        .setSize(aw, ah)
          .setFont(font)
            .setColor(0)  
              .setLineHeight(14)
                .setColorBackground(color(255, 100))
                  .setColorForeground(color(255, 100))
                    .setLineHeight(20)
                      ;

    createProduct = cp5.addButton("createProduct")
      .setPosition(cx, cy)
        .setSize(cw, ch)
          .setId(0)
            .setVisible(false)
              ;

    showName = cp5.addButton("showName")
      .setPosition(shx, shy)
        .setSize(shw, shh)
          .setId(0)  //ID 0 represents system operations
            .setVisible(false)
              ;

    deleteProduct = cp5.addButton("deleteProduct")
      .setPosition(dx, dy)
        .setSize(dw, dh)
          .setId(0) //ID 0 represents system operations to distinguish from selection buttons
            .setVisible(false)
              ;

    modifyProduct = cp5.addButton("modifyProduct")
      .setPosition(modx, mody)
        .setSize(modw, modh)
          .setId(0)  //ID 0 represents system operations
            .setSwitch(true)
              .setVisible(false)
                ;

    bm = new ButtonMatrix(cp5, "bm", buttonMatrixValue, mc, mx, my, mcm, mrm, mw, mh);  
    textFont(font);
  }
  
  public void keyPressed()
  {
    if(modifyingInfo)
    {
      String infoString = currentProduct.getInfo();
      if(keyCode == BACKSPACE)
      {
        currentProduct.setInfo(infoString.substring(0,infoString.length()-1));
      }
      else currentProduct.setInfo(""+infoString+key);
      info.setText(currentProduct.getInfo());
    }
  }
  public void controlEvent(ControlEvent theEvent)
  {
    if(theEvent.controller().name().equals("searchName"))
    {
      system.onSearch(theEvent.controller().stringValue()); // tell the system there has been a search 
    }
    else if(theEvent.controller().name().equals("modifyProduct"))
    {
      system.onModify(currentProduct);  // tell the system that the product is going to be modified 
    }
    else if(theEvent.controller().name().equals("deleteProduct"))
    {
      system.onDelete(currentProduct);  // tell the system that the product is going to be deleted
    }
    else if(theEvent.controller().name().equals("createProduct"))
    {
      system.onCreate(searchName.getText());  // tell the system that the product is going to be deleted
    }
    else if(theEvent.controller().value() == buttonMatrixValue)
    {
      println("Controller Id: " + theEvent.controller().getId());
      system.onResultSelect(theEvent.controller().getId());
    } 
  }
  public void showSearchResults(ArrayList results)
  {
    bm.clear();
    bm.addButtonList(results);
  }
  public void showProduct(Product product)
  {
    currentProduct = product;
    info.setText(product.getInfo());
    showName.setLabel(product.getName());
    setProductButtonsVisible(true);
  }
  private void setProductButtonsVisible(boolean state)
  {
    showName.setVisible(state);
    modifyProduct.setVisible(state);
    deleteProduct.setVisible(state);
  }
  public void setCreateProductVisible(boolean state)
  {
    createProduct.setVisible(state);
  }
  public void toggleModify()
  {
    modifyingInfo = !modifyingInfo;
  }
}