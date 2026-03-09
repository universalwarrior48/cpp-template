#include "core/hello.hpp"
#include <gtest/gtest.h>
#include <string>

TEST(CoreTest, Hello)
{
    EXPECT_EQ(core::hello(), std::string("Hello from core library"));
}