void main() {
  String name = 'MARRY';
  int age = 25;

  print('Name: $name, Age: $age');

  if (age >= 18) {
    print('$name is an adult.');
  } else {
    print('$name is a minor.');
  }

  for (int i = 1; i <= 4; i++) {
    print('Count: $i');
  }

  greet(name);
}

void greet(String name) {
  print('Hello, $name!');
}
