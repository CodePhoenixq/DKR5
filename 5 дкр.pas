
type
  TCompareFunc = function(a, b: Integer): Boolean;

procedure Swap(var a, b: Integer);
var
  temp: Integer;
begin
  temp := a;
  a := b;
  b := temp;
end;

function DefaultCompare(a, b: Integer): Boolean;
begin
  Result := a > b; // Сравнение по возрастанию
end;

function ReverseCompare(a, b: Integer): Boolean;
begin
  Result := a < b; // Сравнение по убыванию
end;

procedure InsertionSort(var arr: array of Integer; n: Integer; compare: TCompareFunc);
var
  i, j, key: Integer;
begin
  for i := 1 to n - 1 do
  begin
    key := arr[i];
    j := i - 1;

    // Перемещаем элементы arr[0..i-1], которые больше key, на одну позицию вперед
    while (j >= 0) and compare(arr[j], key) do
    begin
      arr[j + 1] := arr[j];
      Dec(j);
    end;
    arr[j + 1] := key;
  end;
end;

procedure Heapify(var arr: array of Integer; n, i: Integer; compare: TCompareFunc);
var
  largest, left, right: Integer;
begin
  largest := i; // Инициализируем наибольший элемент как корень
  left := 2 * i + 1; // Левый дочерний элемент
  right := 2 * i + 2; // Правый дочерний элемент

  // Если левый дочерний элемент больше корня
  if (left < n) and compare(arr[left], arr[largest]) then
    largest := left;

  // Если правый дочерний элемент больше наибольшего элемента
  if (right < n) and compare(arr[right], arr[largest]) then
    largest := right;

  // Если наибольший элемент не корень
  if largest <> i then
  begin
    Swap(arr[i], arr[largest]); // Меняем местами
    // Рекурсивно хипифицируем затронутое поддерево
    Heapify(arr, n, largest, compare);
  end;
end;

procedure HeapSort(var arr: array of Integer; n: Integer; compare: TCompareFunc);
var
  i: Integer;
begin
  // Построение кучи (перегруппировка массива)
  for i := n div 2 - 1 downto 0 do
    Heapify(arr, n, i, compare);

  // Один за другим извлекаем элементы из кучи
  for i := n - 1 downto 1 do
  begin
    Swap(arr[0], arr[i]); // Перемещаем текущий корень в конец
    Heapify(arr, i, 0, compare); // Вызываем хипификацию на уменьшенной куче
  end;
end;

procedure PrintArray(arr: array of Integer; n: Integer);
var
  i: Integer;
begin
  for i := 0 to n - 1 do
    Write(arr[i], ' ');
  Writeln;
end;

procedure ReadArrayFromFile(var arr: array of Integer; const fileName: string; var n: Integer);
var
  f: TextFile;
  temp: Integer;
begin
  AssignFile(f, fileName);
  Reset(f);
  
  n := 0;  // Начальное количество элементов
  SetLength(arr, 0);  // Изначально массив пустой
  
  // Считываем данные из файла
  while not Eof(f) do
  begin
    Read(f, temp);
    SetLength(arr, n + 1); // Увеличиваем размер массива
    arr[n] := temp;        // Записываем в массив
    Inc(n);                // Увеличиваем количество элементов
  end;

  CloseFile(f);
end;

var
  arr: array of Integer;
  n, i: Integer;
  fileName: string;

begin
  Write('Введите имя файла: ');
  ReadLn(fileName);
  
  // Считываем массив из файла
  ReadArrayFromFile(arr, fileName, n);

  // Проверяем, были ли считаны данные
  if n = 0 then
  begin
    Writeln('Массив пуст. Проверьте файл.');
    Exit;
  end;

  // Сортировка вставками
  Writeln('Массив до сортировки вставками:');
  PrintArray(arr, n);
  InsertionSort(arr, n, DefaultCompare);
  Writeln('Массив после сортировки вставками:');
  PrintArray(arr, n);

  // Сортировка кучей
  Writeln('Массив до пирамидальной сортировки:');
  PrintArray(arr, n);
  HeapSort(arr, n, DefaultCompare);
  Writeln('Массив после пирамидальной сортировки:');
  PrintArray(arr, n);
end.
