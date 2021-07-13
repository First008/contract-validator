import hashlib

test = None
test1 = None

with open("test", "r") as f:
    test = f.read()

with open("test1", "r") as f:
    test1 = f.read()


test_m = hashlib.sha256()
test_m.update(test.encode('ascii'))
print(test_m.hexdigest())

test1_m = hashlib.sha256()
test1_m.update(test1.encode('ascii'))
print(test1_m.hexdigest())


assert test == test1
