#include "tensorflow/lite/micro/all_ops_resolver.h"
#include "tensorflow/lite/micro/micro_error_reporter.h"
#include "tensorflow/lite/micro/micro_interpreter.h"
#include "tensorflow/lite/schema/schema_generated.h"
#include "tensorflow/lite/version.h"

#include "tensorflow/lite/micro/testing/micro_test.h"

#include "tensorflow/lite/micro/examples/hello_world/model.h"

#include <iostream>

int main() {

    const tflite::Model* model = ::tflite::GetModel(g_model);
    
    std::cout << "model->version(): " << model->version() << std::endl;

    // An AllOpsResolver instance is declared.
    // This will be used by the interpreter to access the operations
    // that are used by the model 
    // tflite::AllOpsResolver resolver;

    

}

