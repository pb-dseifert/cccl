//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// <array>

// void swap(array& a);

#include <array>
#include <cassert>

// std::array is explicitly allowed to be initialized with A a = { init-list };.
// Disable the missing braces warning for this reason.
#include "disable_missing_braces_warning.h"

int main(int, char**) {
  {
    typedef double T;
    typedef std::array<const T, 0> C;
    C c = {};
    C c2 = {};
    // expected-error-re@array:* {{{{(static_assert|static assertion)}} failed {{.*}}{{"?}}cannot swap zero-sized array of type 'const T'{{"?}}}}
    c.swap(c2); // expected-note {{requested here}}
  }

  return 0;
}
