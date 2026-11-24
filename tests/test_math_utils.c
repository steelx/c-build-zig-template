#include "math_utils.h"
#include "unity.h"

void setUp(void) {}

void tearDown(void) {}

static void add_positive_integers(void) {
  TEST_ASSERT_EQUAL_INT(42, add(20, 22));
}

static void add_negative_and_positive_integers(void) {
  TEST_ASSERT_EQUAL_INT(-3, add(-5, 2));
}

static void add_zeroes(void) {
  TEST_ASSERT_EQUAL_INT(0, add(0, 0));
}

int main(void) {
  UNITY_BEGIN();
  RUN_TEST(add_positive_integers);
  RUN_TEST(add_negative_and_positive_integers);
  RUN_TEST(add_zeroes);
  return UNITY_END();
}
