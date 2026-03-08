#include <gtest/gtest.h>
#include "core/hello.hpp"

TEST(CoreTest, Hello)
{
    EXPECT_EQ(core::hello(), "Hello from core library");
}