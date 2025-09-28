class StackNode inherits Object {
  data : Object;
  next : StackNode;

  init(i : Object, n : StackNode) : StackNode {
    { data <- i; next <- n; self; }
  };

  getData() : Object { data };
  getNext() : StackNode { next };

  setNext(n : StackNode) : SELF_TYPE {
    { next <- n; self; }
  };
};

class Queue inherits Object {
  front : StackNode;  -- 空时为 void
  rear  : StackNode;  -- 空时为 void

  initQueue() : SELF_TYPE {
    {
      -- 把 front/rear 设为 void：用一个未初始化的同类型临时变量来产生 void 值
      let v1 : StackNode in front <- v1;
      let v2 : StackNode in rear  <- v2;
      self;
    }
  };

  isEmpty() : Bool { isvoid front };

  enqueue(data : Object) : SELF_TYPE {
    {
      let v : StackNode in
      let newNode : StackNode <- (new StackNode).init(data, v) in {
        if isEmpty() then {
          front <- newNode;
          rear  <- newNode;
        } else {
          rear.setNext(newNode);
          rear <- newNode;
        } fi;
      };
      self;
    }
  };

  dequeue() : Object {
    if isEmpty() then {
      new Object;
    } else {
      let d : Object <- front.getData() in {
        front <- front.getNext();
        if isvoid front then {
          let v : StackNode in rear <- v;
        } else {
          -- 保持 rear 不变；放个无害表达式占位
          new Object;
        } fi;
        d;
      };
    } fi
  };

  frontData() : Object {
    if isEmpty() then { new Object; } else { front.getData(); } fi
  };

  print() : Object {
    if isEmpty() then {
      (new IO).out_string("Queue is empty!\n");
    } else {
      let p : StackNode <- front in
      while not isvoid p loop {
        case p.getData() of
          s : String => (new IO).out_string(s);
          i : Int    => (new IO).out_int(i);
          o : Object => (new IO).out_string(o.type_name());
        esac;
        (new IO).out_string(" ");
        p <- p.getNext();
      } pool;
    } fi
  };

  size() : Int {
    let count : Int <- 0, p : StackNode <- front in {
      while not isvoid p loop {
        count <- count + 1;
        p <- p.getNext();
      } pool;
      count;
    }
  };
};

class Main inherits IO {
  main() : Object {
    let q : Queue <- (new Queue).initQueue() in {
      q.print();

      q.enqueue("First");
      q.enqueue(2);
      q.enqueue("Third");
      q.print();

      out_string("\n=== Testing Front Data ===\n");
      if q.isEmpty() then {
        out_string("Queue is empty, no front data\n");
      } else {
        out_string("Front: ");
        case q.frontData() of
          s : String => out_string(s);
          i : Int    => out_int(i);
          o : Object => out_string(o.type_name());
        esac;
        out_string("\n");
      } fi;

      q.dequeue();
      q.print();

      q.dequeue();
      q.dequeue();
      q.print();
    }
  };
};
