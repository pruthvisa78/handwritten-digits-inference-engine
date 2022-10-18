-----------------Description of files-------------------
arr2num.m       :Function to determine the digit from the obatined 1x10 array after prediction.  
demo.m          :MATLAB script to run 10 test cases each for every digit and give output of trained network.
rand_lfsr_512.m :Function to generate W10 weight values from LFSR logic.
ReLU.m          :Function to calculate ReLU activation.
test_sample.mat :File that contains 10 test samples from 493 cases containing all 10 digits in ascending order.
top_module.m    :MATLAB script to run all 493 test images and give accuracy as result.
Weights_512.mat :File to access weights for output layer (W21) which were calculated during training.
X_test.mat      :Test inputs for test data set of 493 images.
Y_test.mat      :Corresponding outputs for test inputs of 493 images.

-----------------Instructions to run simulation---------------------
To test accuracy of training : Run top_module.m (Include: rand_lfsr_512.m, ReLU.m, Weights_512.mat, X_test.m, Y_test.m)

To test sample set of 10 of each digit occuring once : Run demo.m (Include: test_sample.mat, ReLU.m, rand_lfsr_512.m, Weights_512.mat, arr2num.m)