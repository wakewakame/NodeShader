# Component Class  
## 概要  
コンポーネントクラス  
このクラスを継承し、メンバ関数をオーバーライドして使用する  
作成したコンポーネントは既存のComponentクラスに追加して使う  
### Component root  
ルートコンポーネント  
### Component parent  
親コンポーネント  
### String name  
コンポーネント名  
### Component(int x, int y, int w, int h)  
コンストラクタ  

* x : コンポーネントのローカルx座標  
* y : コンポーネントのローカルy座標  
* w : コンポーネントの幅  
* h : コンポーネントの高さ  

### String setup()  
抽象メソッド  
コンポーネントが追加された直後に実行される

* 戻り値 : コンポーネントの名称  
### void update()  

抽象メソッド  
毎フレーム実行される  
### void draw()  
抽象メソッド  
全てのコンポーネントのupdate関数が実行された後に実行される  
### Component add(Component child)
子コンポーネントを追加するクラス  

* child : 追加する子コンポーネントのインスタンス  
* 戻り値 : 引数のインスタンスをそのまま返す

### void mouseEvent(String type, int x, int y, int start_x, int start_y)
マウスイベント処理関数  
オーバーライドして使用する  
デフォルトではコンポーネントをドラッグで移動できる処理が行われる  

* type : イベントタイプ  
	* "HIT" : コンポーネント上にマウスが存在している間は毎フレーム発生  
	* "DOWN" : コンポーネント上でマウスのボタンが押された瞬間に発生  
	* "UP" : コンポーネント上でマウスのボタンが離された瞬間に発生  
	* "MODE" : コンポーネント上でドラッグ以外のマウス移動が行われた瞬間に発生  
	* "DRAG" : コンポーネント上でドラッグが行われている間は毎フレーム発生  
	* "CLICK" : コンポーネント上でクリックされた瞬間に発生  
* x : イベント発生時のマウスのローカルx座標  
* y : イベント発生時のマウスのローカルy座標  
* start_x : ドラッグ開始地点のマウスのローカルx座標  
* start_y : ドラッグ開始地点のマウスのローカルy座標  

### boolean checkHit(float px, float py)  
親コンポーネントのローカル座標(px, py)が、自コンポーネントの内側にあるかどうかを判定  

### Component getHit(float px, float py)  
自コンポーネント以下のコンポーネントで、自コンポーネントのローカル座標(px, py)にある最前面のコンポーネントを返す  

### PVector getGrobalPos(float px, float py)  
自コンポーネントのローカル座標(px, py)をrootコンポーネントのローカル座標に変換する  

### void activeChilds(Component c)  
任意の子コンポーネントを最前面に表示する  

# RootComponent Class  
## 概要  
Component派生クラス  
全てのコンポーネントの先祖になるクラス  
始めにこのコンポーネントをインスタンス化してから他のコンポーネントを追加してゆく  
### RootComponent()  
コンストラクタ  
ウィンドウ全体に張り付くようにコンポーネントを作成する  
### void update()  
全ての子コンポーネントのupdate関数を実行する  
### void draw()  
全ての子コンポーネントのdraw関数を実行する  

# DefaultComponent Class  
## 概要  
Component派生クラス  
最低限の要素だけを描画するコンポーネント  
外枠とコンポーネント名を表示する  