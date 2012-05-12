#import('dart:html');

void main() {
  run(); 
}

void run() {
  CanvasElement canvas = document.query('#world');
  WebGLRenderingContext gl = canvas.getContext('experimental-webgl');
  // 頂点座標
  var vertices = [
    0.0, 0.5, 0.0,
    0.5, -0.5, 0.0,
    -0.5, -0.5, 0.0
  ];
  var vbuf = gl.createBuffer();
  gl.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, vbuf);
  gl.bufferData(WebGLRenderingContext.ARRAY_BUFFER, new Float32Array(vertices), WebGLRenderingContext.STATIC_DRAW);
  gl.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, gl.createBuffer());
  // 頂点カラー
  var colors = [
    1.0, 0.0, 0.0, 1.0,
    0.0, 1.0, 0.0, 1.0,
    0.0, 0.0, 1.0, 1.0
  ];
  var cbuf = gl.createBuffer();
  gl.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, cbuf);
  gl.bufferData(WebGLRenderingContext.ARRAY_BUFFER, new Float32Array(colors), WebGLRenderingContext.STATIC_DRAW);
  gl.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, gl.createBuffer());
  // インデックス
  var indices = [ 0, 1, 2 ];
  var ibuf = gl.createBuffer();
  gl.bindBuffer(WebGLRenderingContext.ELEMENT_ARRAY_BUFFER, ibuf);
  gl.bufferData(WebGLRenderingContext.ELEMENT_ARRAY_BUFFER, new Int16Array(indices), WebGLRenderingContext.STATIC_DRAW);
  gl.bindBuffer(WebGLRenderingContext.ELEMENT_ARRAY_BUFFER, gl.createBuffer());
  // 頂点シェーダー
  var vshader = gl.createShader(WebGLRenderingContext.VERTEX_SHADER);
  gl.shaderSource(vshader, document.query('#vshader').innerHTML);
  gl.compileShader(vshader);
  if ( !gl.getShaderParameter(vshader, WebGLRenderingContext.COMPILE_STATUS)) {
    throw new Exception(gl.getShaderInfoLog(vshader));
  }
  // フラグメントシェーダー
  var fshader = gl.createShader(WebGLRenderingContext.FRAGMENT_SHADER);
  gl.shaderSource(fshader, document.query('#fshader').innerHTML);
  gl.compileShader(fshader);
  if ( !gl.getShaderParameter(fshader, WebGLRenderingContext.COMPILE_STATUS)) {
    throw new Exception(gl.getShaderInfoLog(fshader));
  }
  var program = gl.createProgram();
  gl.attachShader(program, vshader);
  gl.attachShader(program, fshader);
  gl.bindAttribLocation(program, 0, 'position');
  gl.bindAttribLocation(program, 1, 'color');
  gl.linkProgram(program);
  if ( !gl.getProgramParameter(program, WebGLRenderingContext.LINK_STATUS)) {
    throw new Exception(gl.getProgramInfoLog(program));
  }
  // 描画
  gl.clearColor(0, 0, 0, 1);
  gl.clearDepth(1000);
  gl.clear(WebGLRenderingContext.COLOR_BUFFER_BIT | WebGLRenderingContext.DEPTH_BUFFER_BIT);
  gl.enable(WebGLRenderingContext.DEPTH_TEST);
  gl.useProgram(program);
  gl.enableVertexAttribArray(0);
  gl.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, vbuf);
  gl.vertexAttribPointer(0, 3, WebGLRenderingContext.FLOAT, false, 0, 0);
  gl.enableVertexAttribArray(1);
  gl.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, cbuf);
  gl.vertexAttribPointer(1, 4, WebGLRenderingContext.FLOAT, false, 0, 0);
  gl.bindBuffer(WebGLRenderingContext.ELEMENT_ARRAY_BUFFER, ibuf);
  gl.drawElements(WebGLRenderingContext.TRIANGLES, 3, WebGLRenderingContext.UNSIGNED_SHORT, 0);
  gl.flush();
}
