#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#include <iostream>
#include <vector>

const char *vertexShaderSource =
"#version 460 core\n"
"layout (location = 0) in vec3 inPos;"
"layout (location = 1) in vec3 inColor;"
""
"uniform mat4 model;"
""
"out vec3 outColor;"
""
"void main()\n"
"{\n"
"   gl_Position = model * vec4(inPos, 1.0f);"
"   outColor = inColor;"
"}\0";

const char *fragmentShaderSource =
"#version 460 core\n"
"out vec4 FragColor;\n"
"in vec3 outColor;\n"
"void main()\n"
"{\n"
"   FragColor = vec4(outColor, 1.0f);\n"
"}\0";

void framebuffer_size_callback(GLFWwindow* window, int width, int height)
{
    glViewport(0, 0, width, height);
}

#define CHECK_SHADER(shader, type) \
{ \
    int success; \
    char infoLog[512]; \
    glGetShaderiv(shader, GL_COMPILE_STATUS, &success); \
    if (!success) \
    { \
        glGetShaderInfoLog(shader, 512, NULL, infoLog); \
        std::cout << "ERROR::SHADER::" << type << "::COMPILATION_FAILED\n" << infoLog << std::endl; \
    } \
}

int SCREEN_WIDTH = 800;
int SCREEN_HEIGHT = 600;

int main() {
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 4);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 6);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

    GLFWwindow* window = glfwCreateWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "SOP - Lineær Algebra", NULL, NULL);
    if (window == NULL)
    {
        std::cout << "Failed to create GLFW window" << std::endl;
        glfwTerminate();
        return -1;
    }
    glfwMakeContextCurrent(window);

    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
    {
        std::cout << "Failed to initialize GLAD" << std::endl;
        return -1;
    }

    glViewport(0, 0, 800, 600);
    glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);  
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);

    float vertices[] = {
        -0.25f, -0.25f, 0.0f, 1.0f, 0.0f, 0.0f,
        0.25f, -0.25f, 0.0f, 0.0f, 1.0f, 0.0f,
        0.0f,  0.25f, 0.0f , 0.0f, 0.0f, 1.0f
    };

    unsigned int VAO;
    glGenVertexArrays(1, &VAO);
    glBindVertexArray(VAO);

    unsigned int VBO;
    glGenBuffers(1, &VBO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(0);

    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)(3 * sizeof(float)));
    glEnableVertexAttribArray(1);

    unsigned int vertexShader;
    vertexShader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertexShader, 1, &vertexShaderSource, NULL);
    glCompileShader(vertexShader);

    CHECK_SHADER(vertexShader, "VERTEX")

    unsigned int fragmentShader;
    fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &fragmentShaderSource, NULL);
    glCompileShader(fragmentShader);

    CHECK_SHADER(fragmentShader, "FRAGMENT")

    unsigned int shaderProgram;
    shaderProgram = glCreateProgram();
    glAttachShader(shaderProgram, vertexShader);
    glAttachShader(shaderProgram, fragmentShader);
    glLinkProgram(shaderProgram);

    CHECK_SHADER(shaderProgram, "PROGRAM")

    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);

    std::vector<glm::vec3> trianglePositions = {
        glm::vec3(-0.5f, 0.0f, 0.0f),
        glm::vec3(0.0f, 0.0f, 0.0f),
        glm::vec3(0.5f, 0.0f, 0.0f)
    };

    unsigned int modelLoc = glGetUniformLocation(shaderProgram, "model");
    unsigned int projectionLoc = glGetUniformLocation(shaderProgram, "projection");
    
    while(!glfwWindowShouldClose(window))
    {
        glClear(GL_COLOR_BUFFER_BIT);
        
        glUseProgram(shaderProgram);
        glBindVertexArray(VAO);

        glm::mat4 projection = glm::identity<glm::mat4>();
        glUniformMatrix4fv(projectionLoc, 1, GL_FALSE, glm::value_ptr(projection));

        float time = (float)glfwGetTime();
        for (size_t i = 0; i < trianglePositions.size(); ++i) {
            glm::mat4 transform = glm::mat4(1.0f);
            
            transform = glm::translate(transform, trianglePositions[i]);
            
            float angle = (time + (float)i) * glm::radians(60.0f);
            transform = glm::rotate(transform, angle, glm::vec3(0.0f, 0.0f, 1.0f));
            
            float scaleAmount = sin(time + i) * 0.5f + 1.0f;
            transform = glm::scale(transform, glm::vec3(scaleAmount, scaleAmount, scaleAmount));
            
            glUniformMatrix4fv(modelLoc, 1, GL_FALSE, glm::value_ptr(transform));
            glDrawArrays(GL_TRIANGLES, 0, 3);
        }

        glfwSwapBuffers(window);
        glfwPollEvents();    
    }

    glfwTerminate();

    return 0;
}

