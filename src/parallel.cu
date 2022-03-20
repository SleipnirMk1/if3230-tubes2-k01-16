
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "serial.c"

// Parallel odd-even sort
__global__ void parallel_odd_even(int *d_arr, int num_of_elements) {
  int idx = threadIdx.x;
  int temp;

  // Get every odd index
  idx = idx * 2 + 1;

  // Make sure no index out of range
  if (idx <= num_of_elements-2) { 
      // Check with left
      if (d_arr[idx-1] > d_arr[idx]) { 
          // Swap
          temp = d_arr[idx-1];
          d_arr[idx-1] = d_arr[idx];
          d_arr[idx] = temp;
      }
  }

  // Idk why, checking right and left in the same if statement yields wrong results
  if (idx <= num_of_elements-2) { 
      // Check with right
      if (d_arr[idx+1] < d_arr[idx]) {
          // Swap
          temp = d_arr[idx];
          d_arr[idx] = d_arr[idx+1];
          d_arr[idx+1] = temp;
      }
  }

}

// Sort that is called on main
// Usage: d_arr = array to be sorted; num_of_elements = array length
void odd_even(int *d_arr, int num_of_elements) {

  // Repeat for 1/2 length of input
  for (int i = 0; i <= num_of_elements/2; i++) {
      parallel_odd_even<<<1, num_of_elements>>>(d_arr, num_of_elements);
  }
}

// matrix convolution w/ CUDA
__global__ void convolution_cuda(Matrix *kernel, Matrix *target, Matrix *out, int *row, int *col) {
    int idx = threadIdx.x + blockIdx.x * blockDim.x;

    int intermediate_sum = 0;
    for (int i = 0; i < kernel->row_eff; i++) {
        for (int j = 0; j < kernel->col_eff; j++) {
            intermediate_sum += kernel->mat[i][j] * target->mat[i + idx / *row][j + idx / *col];
        }
    }

    out->mat[idx / *row][idx / *col] = intermediate_sum;
}

int main() {
    
  int kernel_row, kernel_col, target_row, target_col, num_targets, conv_row, conv_col, median, floored_mean;
  int *cu_row, *cu_col, *cu_arr;
  Matrix kernel, output;
  Matrix *arr_mat, *kernel_mat, *target_mat, *output_mat;

  clock_t start = clock();

  // read kernel matrix
  scanf("%d %d", &kernel_row, &kernel_col);
  kernel = input_matrix(kernel_row, kernel_col);

  // read target matrix & data range array
  scanf("%d %d %d", &num_targets, &target_row, &target_col);
  int arr_range[num_targets];
  arr_mat = (Matrix *)malloc(num_targets * sizeof(Matrix));

  // conv matrix row & col 
  conv_row = target_row - kernel_row;
  conv_col = target_col - kernel_col;

  // create output matrix
  init_matrix(&output, conv_row, conv_col);

  // conv row & col memory allocation
	cudaMalloc((void **)&cu_row, sizeof(int));
	cudaMalloc((void **)&cu_col, sizeof(int));

  // sort array memory allocation
  cudaMalloc((void **)&cu_arr, num_targets*sizeof(int));
    
  // matrix memory allocation
	cudaMalloc((void **)&kernel_mat, sizeof(Matrix));
	cudaMalloc((void **)&target_mat, sizeof(Matrix)); 
	cudaMalloc((void **)&output_mat, sizeof(Matrix));

  // copy conv row & col
	cudaMemcpy(cu_row, &conv_row, sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(cu_col, &conv_col, sizeof(int), cudaMemcpyHostToDevice);

  // copy kernel & output matrix
  cudaMemcpy(kernel_mat, &kernel, sizeof(Matrix), cudaMemcpyHostToDevice);
	cudaMemcpy(output_mat, &output, sizeof(Matrix), cudaMemcpyHostToDevice);

  // convolution
  for (int i = 0; i < num_targets; i++) {
      arr_mat[i] = input_matrix(target_row, target_col);
      cudaMemcpy(target_mat, &arr_mat[i], sizeof(Matrix), cudaMemcpyHostToDevice);

      // conv process
      convolution_cuda<<<1,128>>>(kernel_mat, target_mat, output_mat, cu_row, cu_col);

      // write output
      cudaError err = cudaMemcpy(&arr_mat[i], output_mat, sizeof(Matrix), cudaMemcpyDeviceToHost);
      if (err != cudaSuccess) {
        printf("CUDA error copying to Host: %s\n", cudaGetErrorString(err));
      }

      arr_range[i] = get_matrix_datarange(&arr_mat[i]);
  }

  // sorting odd even
  cudaError err = cudaMemcpy(cu_arr, arr_range, num_targets*sizeof(int), cudaMemcpyHostToDevice);
  if(err !=cudaSuccess) {
    printf("CUDA error copying to Device for sorting: %s\n", cudaGetErrorString(err));
  }
  odd_even(cu_arr, num_targets);

  err = cudaMemcpy(arr_range, cu_arr, num_targets*sizeof(int), cudaMemcpyDeviceToHost);
  if(err !=cudaSuccess) {
    printf("CUDA error copying to Host from sorting: %s\n", cudaGetErrorString(err));
  }

  // print the min, max, median, and floored mean of data range array
  median = get_median(arr_range, num_targets);
  floored_mean = get_floored_mean(arr_range, num_targets);
  printf("min: %d\nmax: %d\nmedian: %d\nfloored mean: %d\n",
          arr_range[0],
          arr_range[num_targets - 1],
          median,
          floored_mean);

  // print duration
  double duration = (double)(clock() - start) / CLOCKS_PER_SEC;
  printf("Processing Time: %f\n", duration);

  // Cleanup
  cudaFree(cu_row);
  cudaFree(cu_col);
  cudaFree(kernel_mat);
  cudaFree(target_mat);
  cudaFree(output_mat);

  return 0;
}