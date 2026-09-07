import { useState, useEffect } from "react";
import { AnimatePresence, motion } from "motion/react";
import locales from "../locales/onboarding.json";

type Locale = keyof typeof locales;

const LOGO_URL = "/assets/logo.png";

const AppConfig = {
  PRIVACY_POLICY_URL: "",
  TERMS_OF_SERVICE_URL: ""
};

function Header({ onSkip, skipText, lang, setLang, showSkip = true }: { onSkip: () => void, skipText: string, lang: Locale, setLang: (l: Locale) => void, showSkip?: boolean }) {
  return (
    <header className="fixed top-0 w-full z-50 pt-safe bg-surface/85 backdrop-blur-xl">
      <div className="h-16 px-edge-margin-mobile flex items-center justify-between">
        <div className="flex items-center gap-space-sm">
          <img
            alt="Meowoirs Luxury Brand Emblem"
            className="h-8 w-auto object-contain"
            src={LOGO_URL}
          />
          <span className="font-headline-sm text-[20px] tracking-widest text-primary font-medium">
            MEOWOIRS
          </span>
        </div>
        <div className="flex items-center gap-4">
          <select 
            value={lang} 
            onChange={(e) => setLang(e.target.value as Locale)}
            className="bg-transparent text-primary font-label-caps text-[11px] uppercase tracking-widest outline-none cursor-pointer appearance-none border-none text-right"
          >
            <option value="tr">TR</option>
            <option value="en">EN</option>
            <option value="de">DE</option>
            <option value="fr">FR</option>
            <option value="es">ES</option>
            <option value="it">IT</option>
            <option value="pt">PT</option>
            <option value="ru">RU</option>
            <option value="ja">JA</option>
            <option value="zh">ZH</option>
          </select>
          {showSkip && (
            <button
              onClick={onSkip}
              className="min-h-[44px] flex items-center font-label-caps text-[11px] uppercase tracking-widest text-on-surface-variant hover:text-secondary transition-colors"
            >
              {skipText}
            </button>
          )}
        </div>
      </div>
    </header>
  );
}

function Pagination({ currentStep }: { currentStep: number }) {
  return (
    <div className="fixed bottom-0 w-full z-50 pb-safe pointer-events-none">
      <div className="absolute bottom-0 w-full h-28 bg-gradient-to-t from-surface via-surface/90 to-transparent"></div>
      <div className="relative px-edge-margin-mobile pb-6 flex flex-col items-center gap-5">
        <div className="flex items-center gap-4">
          {[1, 2, 3, 4].map((step) => (
            <div key={step} className="relative flex items-center justify-center w-5 h-5">
              <div
                className={`absolute w-full h-full rounded-full border border-secondary transition-all duration-500 ease-out ${
                  currentStep === step ? "opacity-100 scale-100" : "opacity-0 scale-50"
                }`}
              />
              <div
                className={`rounded-full transition-all duration-500 ${
                  currentStep === step
                    ? "w-1.5 h-1.5 bg-secondary"
                    : currentStep > step
                    ? "w-1 h-1 bg-primary/40"
                    : "w-1 h-1 bg-outline-variant"
                }`}
              />
            </div>
          ))}
        </div>
        <div className="w-32 h-1 rounded-full bg-primary/10"></div>
      </div>
    </div>
  );
}

export default function Onboarding({ onComplete }: { onComplete: () => void }) {
  const [step, setStep] = useState(1);
  const [lang, setLang] = useState<Locale>("tr");

  const t = locales[lang];

  const nextStep = () => setStep((s) => Math.min(s + 1, 4));
  const skipToLegal = () => setStep(4);

  const stepVariants = {
    initial: { opacity: 0 },
    in: { opacity: 1 },
    out: { opacity: 0 },
  };

  const renderStep = () => {
    switch (step) {
      case 1:
        return (
          <motion.div
            key="step1"
            variants={stepVariants}
            initial="initial"
            animate="in"
            exit="out"
            transition={{ duration: 0.3, ease: "easeInOut" }}
            className="flex flex-col w-full pb-24 col-start-1 row-start-1"
          >
            <div className="px-edge-margin-mobile pt-space-sm pb-space-xs flex items-center">
              <span className="font-label-caps text-[11px] tracking-widest text-on-surface-variant uppercase">
                {t.step1_chap}
              </span>
            </div>
            <div className="px-edge-margin-mobile mt-space-xs">
              <div className="relative w-full aspect-[4/5] rounded-[48px] overflow-hidden shadow-xl border-[8px] border-primary bg-background">
                <img
                  alt="Bir pencere kenarında güneş ışığı altında sakince oturan zarif kedi"
                  className="w-full h-full object-cover select-none"
                  src="/assets/screen3.png"
                />
                <div className="absolute inset-0 bg-gradient-to-t from-primary/40 via-transparent to-transparent pointer-events-none"></div>
                <div className="absolute top-space-md right-space-md">
                  <div className="bg-surface/80 backdrop-blur-md px-space-sm py-space-xxs rounded-full shadow-sm flex items-center gap-space-xxs">
                    <span className="material-symbols-outlined text-[14px] text-secondary">
                      flare
                    </span>
                    <span className="font-label-caps text-[11px] text-primary tracking-widest uppercase">
                      {t.step1_badge}
                    </span>
                  </div>
                </div>
                <div className="absolute bottom-space-md left-space-md right-space-md flex items-end justify-between">
                  <div className="bg-surface/90 backdrop-blur-md px-space-sm py-space-xs rounded-xl shadow-sm max-w-[80%]">
                    <p className="font-headline-sm text-[20px] italic text-primary leading-tight">
                      {t.step1_quote}
                    </p>
                  </div>
                  <div className="w-8 h-8 rounded-full bg-surface/90 backdrop-blur-md flex items-center justify-center text-primary shadow-sm">
                    <span className="material-symbols-outlined text-[18px]">
                      auto_stories
                    </span>
                  </div>
                </div>
              </div>
            </div>
            <div className="px-edge-margin-mobile mt-space-lg flex flex-col gap-space-sm">
              <div className="flex items-center gap-space-xs text-secondary font-label-caps text-[11px] tracking-widest uppercase">
                <span>{t.step1_intro}</span>
                <span className="w-4 h-px bg-secondary/40"></span>
                <span>{t.step1_intro_sub}</span>
              </div>
              <h1 className="font-headline-lg text-[30px] text-primary tracking-tight leading-snug">
                {t.step1_title_part1}<span className="italic font-normal text-secondary">{t.step1_title_highlight}</span>{t.step1_title_part2}
              </h1>
              <p className="font-body-lg text-[16px] text-on-surface-variant leading-relaxed">
                {t.step1_desc}
              </p>
            </div>
            <div className="px-edge-margin-mobile mt-space-xl">
              <div className="bg-background rounded-3xl p-space-md shadow-sm border border-outline flex items-start gap-space-sm">
                <div className="w-10 h-10 rounded-xl bg-surface-container-highest flex items-center justify-center shrink-0 text-primary">
                  <span className="material-symbols-outlined text-[20px]">
                    filter_vintage
                  </span>
                </div>
                <div className="flex flex-col min-w-0">
                  <span className="font-title-md text-[16px] text-primary">
                    {t.step1_feature1_title}
                  </span>
                  <span className="font-body-sm text-[12px] text-on-surface-variant mt-0.5 leading-snug">
                    {t.step1_feature1_desc}
                  </span>
                </div>
              </div>
            </div>
            <div className="px-edge-margin-mobile mt-space-xl flex flex-col gap-space-md">
              <button
                onClick={nextStep}
                className="w-full py-4 bg-secondary text-on-secondary rounded-full font-semibold shadow-md hover:shadow-lg active:scale-[0.98] transition-all select-none flex items-center justify-center gap-2"
              >
                <span className="font-title-md text-[16px] tracking-wide">
                  {t.btn_continue}
                </span>
                <span className="material-symbols-outlined text-[20px]">
                  arrow_forward
                </span>
              </button>
              <div className="flex items-center justify-center gap-space-xs py-space-xxs">
                <span className="font-label-caps text-[11px] text-on-surface-variant uppercase tracking-widest">
                  {t.step1_footer1}
                </span>
                <span className="text-on-surface-variant">•</span>
                <span className="font-label-caps text-[11px] text-on-surface-variant uppercase tracking-widest">
                  {t.step1_footer2}
                </span>
              </div>
            </div>
          </motion.div>
        );

      case 2:
        return (
          <motion.div
            key="step2"
            variants={stepVariants}
            initial="initial"
            animate="in"
            exit="out"
            transition={{ duration: 0.3, ease: "easeInOut" }}
            className="flex flex-col w-full pb-28 col-start-1 row-start-1"
          >
            <div className="px-edge-margin-mobile pt-space-md flex flex-col gap-space-xs">
              <div className="flex items-center gap-space-xs text-secondary">
                <span className="font-label-caps text-[11px] uppercase tracking-widest">
                  {t.step2_chap}
                </span>
              </div>
              <h1 className="font-headline-lg text-[30px] text-primary tracking-tight font-medium">
                {t.step2_title}
              </h1>
              <p className="font-body-md text-[14px] text-on-surface-variant leading-relaxed">
                {t.step2_desc}
              </p>
            </div>
            <div className="relative px-edge-margin-mobile pt-space-lg flex flex-col">
              <div className="absolute left-9 top-0 bottom-0 w-[1px] bg-outline-variant/40 -z-10 pointer-events-none"></div>
              <div className="relative w-full rounded-3xl bg-background border border-outline p-space-xs shadow-xl transition-transform duration-300">
                <div className="relative w-full aspect-[4/3] rounded-[24px] overflow-hidden bg-surface-container-high shadow-inner">
                  <img
                    alt="Curled sleeping tabby cat on a textured cream knitted wool blanket"
                    className="w-full h-full object-cover object-center transform scale-[1.01] hover:scale-105 transition-transform duration-700 ease-out"
                    src="/assets/screen.png"
                  />
                  <div className="absolute inset-0 bg-gradient-to-t from-primary-container/40 via-transparent to-transparent pointer-events-none"></div>
                  <div className="absolute top-space-sm left-space-sm px-space-xs py-1 rounded-full bg-surface/90 backdrop-blur-md shadow-sm flex items-center gap-1.5">
                    <span className="w-2 h-2 rounded-full bg-tertiary-container animate-pulse"></span>
                    <span className="font-label-caps text-[11px] uppercase tracking-wider text-on-surface">
                      {t.step2_badge1}
                    </span>
                  </div>
                  <div className="absolute bottom-space-sm left-space-sm px-space-sm py-1 rounded-full bg-surface-container-lowest/90 backdrop-blur-md shadow-sm flex items-center gap-1 text-on-surface-variant">
                    <span className="material-symbols-outlined text-[14px]">
                      nest_clock_farsight_analog
                    </span>
                    <span className="font-label-md text-[13px]">
                      {t.step2_badge2}
                    </span>
                  </div>
                </div>
                <div className="mt-space-sm p-space-md rounded-3xl bg-tertiary/10 border border-tertiary/20 flex flex-col gap-space-sm">
                  <div className="flex items-center justify-between gap-space-xs flex-wrap">
                    <span className="font-headline-sm text-[20px] italic text-secondary tracking-normal">
                      {t.step2_quote_title}
                    </span>
                    <span className="px-space-xs py-0.5 rounded-full bg-tertiary-fixed text-on-tertiary-fixed font-label-caps text-[11px] tracking-wider flex items-center gap-1">
                      <span className="material-symbols-outlined text-[13px]">
                        spa
                      </span>
                      {t.step2_quote_tag}
                    </span>
                  </div>
                  <div className="relative pl-space-sm">
                    <div className="absolute left-0 top-0 bottom-0 w-[2px] bg-secondary-container rounded-full"></div>
                    <p className="font-headline-sm text-[20px] text-primary italic font-normal leading-snug">
                      {t.step2_quote}
                    </p>
                  </div>
                </div>
              </div>
              <div className="mt-space-xl px-space-md py-space-sm rounded-3xl bg-background border border-outline flex items-center gap-space-sm">
                <span className="material-symbols-outlined text-secondary text-[22px] flex-shrink-0">
                  auto_stories
                </span>
                <p className="font-body-sm text-[12px] text-on-surface-variant italic">
                  {t.step2_footer_text}
                </p>
              </div>
            </div>
            <div className="px-edge-margin-mobile pt-space-xl flex flex-col gap-space-sm">
              <button
                onClick={nextStep}
                className="w-full py-4 bg-secondary text-on-secondary rounded-full font-semibold shadow-md hover:shadow-lg active:scale-[0.98] transition-all select-none flex items-center justify-center gap-2 group"
              >
                <span>{t.btn_continue}</span>
                <span className="material-symbols-outlined text-[20px] group-hover:translate-x-0.5 transition-transform">
                  east
                </span>
              </button>
              <div className="flex items-center justify-center gap-1.5 text-outline pt-1">
                <span className="font-label-caps text-[11px] uppercase tracking-widest text-on-surface-variant">
                  {t.step2_footer1}
                </span>
                <span className="text-outline-variant">•</span>
                <span className="font-label-caps text-[11px] uppercase tracking-widest text-outline">
                  {t.step2_footer2}
                </span>
              </div>
            </div>
          </motion.div>
        );

      case 3:
        return (
          <motion.div
            key="step3"
            variants={stepVariants}
            initial="initial"
            animate="in"
            exit="out"
            transition={{ duration: 0.3, ease: "easeInOut" }}
            className="flex flex-col w-full px-edge-margin-mobile pb-28 col-start-1 row-start-1"
          >
            <div className="pt-space-md flex items-center justify-between">
              <span className="font-label-caps text-[11px] uppercase text-secondary tracking-widest">
                {t.step3_chap}
              </span>
            </div>
            <header className="mt-space-lg space-y-space-xs">
              <h1 className="font-display-sm text-[36px] text-primary tracking-tight leading-tight break-words">
                {t.step3_title}
              </h1>
              <p className="font-body-md text-[14px] text-on-surface-variant leading-relaxed break-words">
                {t.step3_desc}
              </p>
            </header>
            <section className="relative mt-space-xl pb-space-sm">
              <div className="relative w-11/12 ml-auto shadow-md rounded-3xl bg-background border border-outline p-2">
                <div className="relative overflow-hidden rounded-[24px] aspect-[4/5] bg-surface-container-high">
                  <img
                    alt="Güneş ışığında şefkatle sevilen kedi"
                    className="w-full h-full object-cover select-none"
                    src="/assets/screen1.png"
                  />
                  <div className="absolute inset-0 bg-gradient-to-t from-primary/60 via-transparent to-transparent"></div>
                  <div className="absolute top-3 right-3">
                    <span className="px-2.5 py-1 rounded-full bg-tertiary-fixed/90 text-on-tertiary-fixed font-label-caps text-[11px] tracking-wider backdrop-blur-sm">
                      {t.step3_badge1}
                    </span>
                  </div>
                  <div className="absolute bottom-3 left-3 right-3 text-on-primary">
                    <p className="font-headline-sm text-[20px] font-normal drop-shadow-sm">
                      {t.step3_card1_title}
                    </p>
                    {t.step3_card1_desc && (
                      <p className="font-label-md text-[13px] text-primary-fixed-dim">
                        {t.step3_card1_desc}
                      </p>
                    )}
                  </div>
                </div>
              </div>
              <div className="relative -mt-16 w-9/12 mr-auto shadow-xl rounded-3xl bg-background border border-outline p-2">
                <div className="relative overflow-hidden rounded-[24px] aspect-square bg-surface-container-high">
                  <img
                    alt="Taş merdivenlerde yatan sokak kedisi"
                    className="w-full h-full object-cover select-none"
                    src="/assets/screen.png"
                  />
                  <div className="absolute inset-0 bg-gradient-to-t from-primary/65 via-transparent to-transparent"></div>
                  <div className="absolute top-2.5 left-2.5">
                    <span className="px-2.5 py-1 rounded-full bg-secondary-fixed text-on-secondary-fixed font-label-caps text-[11px] tracking-wider backdrop-blur-sm">
                      {t.step3_badge2}
                    </span>
                  </div>
                  <div className="absolute bottom-2.5 left-2.5 right-2.5 text-on-primary">
                    <p className="font-headline-sm text-[20px] font-normal drop-shadow-sm">
                      {t.step3_card2_title}
                    </p>
                    <p className="font-label-md text-[13px] text-secondary-fixed-dim">
                      {t.step3_card2_desc}
                    </p>
                  </div>
                </div>
              </div>
            </section>
            <div className="mt-space-md p-space-md rounded-3xl bg-background border border-outline flex items-center gap-space-sm shadow-sm">
              <div className="w-10 h-10 rounded-full bg-surface-container-lowest flex items-center justify-center text-secondary shrink-0">
                <span className="material-symbols-outlined text-[20px]">
                  auto_stories
                </span>
              </div>
              <div className="min-w-0 flex-1">
                <p className="font-title-md text-[16px] text-primary leading-snug break-words">
                  {t.step3_feature_title}
                </p>
                <p className="font-body-sm text-[12px] text-on-surface-variant break-words mt-1">
                  {t.step3_feature_desc}
                </p>
              </div>
            </div>
            <div className="mt-space-xl flex flex-col gap-space-sm">
              <button
                onClick={nextStep}
                className="w-full py-4 bg-secondary text-on-secondary rounded-full font-semibold shadow-md hover:shadow-lg active:scale-[0.98] transition-all select-none flex items-center justify-center gap-2 group"
              >
                <span>{t.btn_continue}</span>
                <span className="material-symbols-outlined text-[20px] group-hover:translate-x-0.5 transition-transform">
                  east
                </span>
              </button>
              <div className="flex items-center justify-center gap-1.5 text-outline pt-1">
                <span className="font-label-caps text-[11px] uppercase tracking-widest text-on-surface-variant">
                  {t.step3_footer1}
                </span>
                <span className="text-outline-variant">•</span>
                <span className="font-label-caps text-[11px] uppercase tracking-widest text-outline">
                  {t.step3_footer2}
                </span>
              </div>
            </div>
          </motion.div>
        );

      case 4:
        return <LegalStep onComplete={onComplete} stepVariants={stepVariants} t={t} />;
    }
  };

  return (
    <div className="flex-1 w-full bg-surface pt-16 flex flex-col min-h-screen overflow-x-hidden">
      <Header onSkip={skipToLegal} skipText={t.skip} lang={lang} setLang={setLang} showSkip={step < 4} />
      <div className="flex-1 grid">
        <AnimatePresence>
          {renderStep()}
        </AnimatePresence>
      </div>
      <Pagination currentStep={step} />
    </div>
  );
}

function LegalStep({
  onComplete,
  stepVariants,
  t
}: {
  onComplete: () => void;
  stepVariants: any;
  t: any;
}) {
  const [privacyAgreed, setPrivacyAgreed] = useState(false);
  const [termsAgreed, setTermsAgreed] = useState(false);

  const canContinue = privacyAgreed && termsAgreed;

  return (
    <motion.div
      key="step4"
      variants={stepVariants}
      initial="initial"
      animate="in"
      exit="out"
      transition={{ duration: 0.3, ease: "easeInOut" }}
      className="flex flex-col w-full px-edge-margin-mobile pb-space-3xl col-start-1 row-start-1"
    >
      <div className="flex items-center justify-between pt-space-md pb-space-lg">
        <div className="flex items-center gap-space-xs">
          <span className="w-2 h-2 rounded-full bg-secondary"></span>
          <span className="font-label-caps text-[11px] uppercase tracking-widest text-secondary font-bold">
            {t.step4_chap}
          </span>
        </div>
      </div>
      <div className="relative w-full flex flex-col items-center justify-center py-space-xl">
        <div className="relative w-28 h-28 flex items-center justify-center">
          <div className="absolute inset-0 rounded-full bg-secondary-fixed/30 blur-2xl pointer-events-none"></div>
          <div className="relative w-24 h-24 rounded-full bg-surface-container shadow-md flex items-center justify-center p-space-sm">
            <svg
              className="w-14 h-14 text-primary"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 64 64"
            >
              <path
                className="text-primary"
                d="M22 28V19C22 13.477 26.477 9 32 9C37.523 9 42 13.477 42 19V28"
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth="2.5"
              ></path>
              <path
                className="text-secondary"
                d="M22 19L27 12"
                strokeLinecap="round"
                strokeWidth="2.5"
              ></path>
              <path
                className="text-secondary"
                d="M42 19L37 12"
                strokeLinecap="round"
                strokeWidth="2.5"
              ></path>
              <rect
                className="fill-surface-container-low stroke-primary"
                fill="#FFF9F2"
                height="27"
                rx="6"
                strokeWidth="2.5"
                width="34"
                x="15"
                y="27"
              ></rect>
              <circle
                className="fill-secondary stroke-none"
                cx="32"
                cy="38"
                r="3.5"
              ></circle>
              <path
                className="fill-secondary stroke-none"
                d="M30.5 40.5L29 47H35L33.5 40.5"
              ></path>
              <circle
                className="fill-primary stroke-none"
                cx="27"
                cy="35"
                r="1.2"
              ></circle>
              <circle
                className="fill-primary stroke-none"
                cx="37"
                cy="35"
                r="1.2"
              ></circle>
              <circle
                className="fill-primary stroke-none"
                cx="32"
                cy="32.5"
                r="1.2"
              ></circle>
            </svg>
            <div className="absolute -bottom-1 -right-1 w-8 h-8 rounded-full bg-secondary text-on-secondary shadow-sm flex items-center justify-center p-1">
              <img
                alt="Meowoirs Luxury Brand Emblem"
                className="w-5 h-5 object-contain invert opacity-95"
                src={LOGO_URL}
              />
            </div>
          </div>
        </div>
        <div className="w-12 h-0.5 bg-outline-variant/40 mt-space-md rounded-full"></div>
      </div>
      <div className="text-center px-space-xs mt-space-xs">
        <h1 className="font-headline-lg text-[30px] text-primary tracking-tight font-medium">
          {t.step4_title}
        </h1>
        <p className="font-body-md text-[14px] text-on-surface-variant mt-space-sm leading-relaxed max-w-sm mx-auto">
          {t.step4_desc}
        </p>
      </div>
      <div className="mt-space-xl flex flex-col gap-space-sm">
        <div className="bg-background rounded-3xl border border-outline p-space-md shadow-sm flex items-start gap-space-md transition-transform">
          <div className="w-9 h-9 rounded-full bg-secondary/10 text-secondary flex items-center justify-center shrink-0 mt-0.5">
            <span className="material-symbols-outlined text-[18px]">
              ad_units
            </span>
          </div>
          <div className="min-w-0 flex-1">
            <h2 className="font-title-md text-[16px] text-primary font-semibold">
              {t.step4_card_title}
            </h2>
            <p className="font-body-sm text-[12px] text-on-surface-variant mt-0.5">
              {t.step4_card_desc}
            </p>
          </div>
        </div>
      </div>
      <div className="mt-space-xl flex flex-col gap-space-md pt-space-xs">
        <label className="flex items-start gap-space-sm cursor-pointer select-none group min-h-[44px]">
          <div className="relative mt-0.5 shrink-0 flex items-center justify-center">
            <input
              checked={privacyAgreed}
              onChange={(e) => setPrivacyAgreed(e.target.checked)}
              className="peer sr-only"
              type="checkbox"
            />
            <div className="w-5 h-5 rounded-full bg-surface-container-highest border border-outline-variant peer-checked:border-primary peer-checked:bg-primary transition-all flex items-center justify-center shadow-inner">
              <span className="material-symbols-outlined text-surface text-[14px] opacity-0 peer-checked:opacity-100 transition-opacity">
                check
              </span>
            </div>
          </div>
          <span className="font-body-sm text-[12px] text-on-surface leading-snug flex-1">
            {t.step4_privacy_pre}
            <a
              href={AppConfig.PRIVACY_POLICY_URL || "#"}
              target={AppConfig.PRIVACY_POLICY_URL ? "_blank" : "_self"}
              rel="noopener noreferrer"
              onClick={(e) => {
                if (!AppConfig.PRIVACY_POLICY_URL) {
                  e.preventDefault();
                  alert("Privacy Policy will be available before launch.");
                } else {
                  e.stopPropagation();
                }
              }}
              className="font-semibold text-primary underline decoration-outline-variant/60"
            >
              {t.step4_privacy_link}
            </a>
            {t.step4_privacy_post}
          </span>
        </label>
        
        <label className="flex items-start gap-space-sm cursor-pointer select-none group min-h-[44px]">
          <div className="relative mt-0.5 shrink-0 flex items-center justify-center">
            <input
              checked={termsAgreed}
              onChange={(e) => setTermsAgreed(e.target.checked)}
              className="peer sr-only"
              type="checkbox"
            />
            <div className="w-5 h-5 rounded-full bg-surface-container-highest border border-outline-variant peer-checked:border-primary peer-checked:bg-primary transition-all flex items-center justify-center shadow-inner">
              <span className="material-symbols-outlined text-surface text-[14px] opacity-0 peer-checked:opacity-100 transition-opacity">
                check
              </span>
            </div>
          </div>
          <span className="font-body-sm text-[12px] text-on-surface leading-snug flex-1">
            {t.step4_terms_pre}
            <a
              href={AppConfig.TERMS_OF_SERVICE_URL || "#"}
              target={AppConfig.TERMS_OF_SERVICE_URL ? "_blank" : "_self"}
              rel="noopener noreferrer"
              onClick={(e) => {
                if (!AppConfig.TERMS_OF_SERVICE_URL) {
                  e.preventDefault();
                  alert("Terms of Service will be available before launch.");
                } else {
                  e.stopPropagation();
                }
              }}
              className="font-semibold text-primary underline decoration-outline-variant/60"
            >
              {t.step4_terms_link}
            </a>
            {t.step4_terms_post}
          </span>
        </label>
      </div>
      <div className="mt-space-xl flex flex-col gap-space-md">
        <button
          disabled={!canContinue}
          onClick={onComplete}
          className={`w-full py-4 font-semibold text-[16px] rounded-full shadow-md transition-all flex items-center justify-center gap-space-xs group ${
            canContinue
              ? "bg-secondary text-on-secondary hover:shadow-lg active:scale-[0.98]"
              : "opacity-40 pointer-events-none bg-secondary/50 text-on-secondary"
          }`}
          type="button"
        >
          <span>{t.step4_btn}</span>
          <span className="material-symbols-outlined text-[20px] transition-transform group-hover:translate-x-1">
            arrow_forward
          </span>
        </button>
      </div>
      <div className="mt-space-lg flex items-center justify-center gap-space-xs text-on-surface-variant/50">
        <span className="material-symbols-outlined text-[14px]">shield</span>
        <span className="font-label-caps text-[11px] tracking-widest uppercase">
          {t.step4_footer}
        </span>
      </div>
    </motion.div>
  );
}
