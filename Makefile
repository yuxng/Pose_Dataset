CFLAGS = 
LDFLAGS = -lm -lGL -lGLU -lglut

all: anchor_depth_test anchor_depth_test_one

anchor_depth_test: anchor_depth_test.o
	gcc anchor_depth_test.o -o anchor_depth_test $(LDFLAGS)

anchor_depth_test.o: anchor_depth_test.c
	gcc -c $(CFLAGS) anchor_depth_test.c -o anchor_depth_test.o

anchor_depth_test_one: anchor_depth_test_one.o
	gcc anchor_depth_test_one.o -o anchor_depth_test_one $(LDFLAGS)

anchor_depth_test_one.o: anchor_depth_test_one.c
	gcc -c $(CFLAGS) anchor_depth_test_one.c -o anchor_depth_test_one.o
