/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import { useState, useEffect } from "react";
import Onboarding from "./components/Onboarding";
import Home from "./components/Home";

export default function App() {
  const [onboardingCompleted, setOnboardingCompleted] = useState<boolean | null>(null);

  useEffect(() => {
    const isCompleted = localStorage.getItem("onboarding_completed") === "true";
    setOnboardingCompleted(isCompleted);
  }, []);

  const handleOnboardingComplete = () => {
    localStorage.setItem("onboarding_completed", "true");
    localStorage.setItem("accepted_legal_version", "1");
    setOnboardingCompleted(true);
  };

  if (onboardingCompleted === null) {
    return null; // Or a loading spinner
  }

  return onboardingCompleted ? (
    <Home />
  ) : (
    <Onboarding onComplete={handleOnboardingComplete} />
  );
}
