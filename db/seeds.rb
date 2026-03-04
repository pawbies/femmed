# ── Helpers ───────────────────────────────────────────────────────────────────

def c(name) = Category.find_by!(name: name)
def ai(name) = ActiveIngredient.find_by!(name: name)
def l(name) = Labeler.find_by!(name: name)
def f(name) = Form.find_by!(name: name)

# ── Categories ────────────────────────────────────────────────────────────────

[
  "Psychopharmaca",
  "Analgesics",
  "Antidepressants",
  "Antihistamines",
  "Antihypertensives",
  "Antidiabetics",
  "Proton Pump Inhibitors",
  "Statins",
  "Antibiotics",
  "Anticoagulants",
  "Stimulants",
  "Wakefulness-Promoting Agents",
  "Anxiolytics",
  "Antiepileptics",
  "Antiasthmatics",
  "Hormone Replacement Therapy"
].each { Category.find_or_create_by(name: _1) }

# ── Active Ingredients ────────────────────────────────────────────────────────
#
# half_life:                hours
# absorption_rate:          ka (1/hour) — rate of absorption into systemic circulation
# volume_of_distribution:   Vd (litres) — apparent volume drug distributes into
#
# Sources: standard pharmacokinetic literature / FDA prescribing information.
# All values are approximate population means for a 70kg adult.
# Inhaled drugs (Budesonide, Formoterol) reflect pulmonary absorption rate.
# Estradiol Valerate reflects IM depot absorption, not oral.

[
  { name: "Methylphenidate Hydrochloride", half_life:  3.5, absorption_rate: 2.0,  volume_of_distribution:  185.0 },
  { name: "Amphetamine",                   half_life: 11.0, absorption_rate: 1.0,  volume_of_distribution:  245.0 },
  { name: "Lisdexamfetamine",              half_life: 11.0, absorption_rate: 0.5,  volume_of_distribution:  450.0 },
  { name: "Atomoxetine",                   half_life:  5.0, absorption_rate: 1.0,  volume_of_distribution:   60.0 },
  { name: "Modafinil",                     half_life: 13.0, absorption_rate: 0.9,  volume_of_distribution:   63.0 },
  { name: "Armodafinil",                   half_life: 15.0, absorption_rate: 1.0,  volume_of_distribution:   42.0 },
  { name: "Ibuprofen",                     half_life:  2.0, absorption_rate: 2.5,  volume_of_distribution:   10.5 },
  { name: "Paracetamol",                   half_life:  2.5, absorption_rate: 2.0,  volume_of_distribution:   63.0 },
  { name: "Codeine",                       half_life:  3.0, absorption_rate: 1.5,  volume_of_distribution:  245.0 },
  { name: "Sertraline",                    half_life: 26.0, absorption_rate: 0.5,  volume_of_distribution:  300.0 },
  { name: "Fluoxetine",                    half_life: 48.0, absorption_rate: 0.5,  volume_of_distribution: 2800.0 },
  { name: "Venlafaxine",                   half_life:  5.0, absorption_rate: 1.0,  volume_of_distribution:  525.0 },
  { name: "Bupropion",                     half_life: 21.0, absorption_rate: 0.8,  volume_of_distribution: 2000.0 },
  { name: "Cetirizine",                    half_life:  8.0, absorption_rate: 1.5,  volume_of_distribution:   39.0 },
  { name: "Loratadine",                    half_life: 10.0, absorption_rate: 1.5,  volume_of_distribution:  119.0 },
  { name: "Omeprazole",                    half_life:  1.0, absorption_rate: 2.0,  volume_of_distribution:   21.0 },
  { name: "Pantoprazole",                  half_life:  1.0, absorption_rate: 1.5,  volume_of_distribution:   11.0 },
  { name: "Esomeprazole",                  half_life:  1.3, absorption_rate: 1.5,  volume_of_distribution:   16.0 },
  { name: "Metformin",                     half_life:  6.5, absorption_rate: 0.5,  volume_of_distribution:  654.0 },
  { name: "Atorvastatin",                  half_life: 14.0, absorption_rate: 1.0,  volume_of_distribution:  565.0 },
  { name: "Amoxicillin",                   half_life:  1.3, absorption_rate: 1.5,  volume_of_distribution:   18.0 },
  { name: "Clavulanic Acid",               half_life:  1.0, absorption_rate: 1.5,  volume_of_distribution:   14.0 },
  { name: "Naproxen",                      half_life: 14.0, absorption_rate: 1.5,  volume_of_distribution:   11.0 },
  { name: "Warfarin",                      half_life: 40.0, absorption_rate: 1.0,  volume_of_distribution:   10.0 },
  { name: "Lorazepam",                     half_life: 15.0, absorption_rate: 1.5,  volume_of_distribution:   91.0 },
  { name: "Diazepam",                      half_life: 60.0, absorption_rate: 1.5,  volume_of_distribution:   77.0 },
  { name: "Lamotrigine",                   half_life: 30.0, absorption_rate: 0.7,  volume_of_distribution:   77.0 },
  { name: "Gabapentin",                    half_life:  6.0, absorption_rate: 0.8,  volume_of_distribution:   58.0 },
  { name: "Budesonide",                    half_life:  2.5, absorption_rate: 1.5,  volume_of_distribution:  183.0 },
  { name: "Formoterol",                    half_life:  9.0, absorption_rate: 2.0,  volume_of_distribution:  912.0 },
  { name: "Estradiol Valerate",            half_life:  5.0, absorption_rate: 0.2,  volume_of_distribution: 1000.0 }
].each { |attrs| ActiveIngredient.find_or_create_by(name: attrs[:name]).update(attrs) }

# ── Labelers ──────────────────────────────────────────────────────────────────

%w[Novartis Pfizer Bayer Sandoz Shire Sanofi Hexal Mepha AstraZeneca Cephalon Teva Ratiopharm].each { Labeler.find_or_create_by(name: _1) }
[ "Boehringer Ingelheim", "Eli Lilly" ].each { Labeler.find_or_create_by(name: _1) }

# ── Forms ─────────────────────────────────────────────────────────────────────

%w[Capsule Tablet Injection Patch Drop Cream Gel Ointment Spray Inhaler Suppository Powder Lozenge].each { Form.find_or_create_by(name: _1) }
[ "Film-coated Tablet", "Oral Solution", "Effervescent Tablet", "Extended-release Capsule", "Extended-release Tablet", "Chewable Tablet", "Transdermal Patch", "Nasal Spray", "Eye Drop", "Ear Drop" ].each { Form.find_or_create_by(name: _1) }
# ── Medications & Versions ────────────────────────────────────────────────────
#
# unit enum (MedicationVersionIngredient):
#   0 => :mg
#   1 => :mcg
#   2 => :ml
#
# Each version entry accepts an `ingredients` array of { name:, amount:, unit: }
# to populate medication_version_ingredients.

[
  {
    name: "Ritalin LA",
    labeler: l("Novartis"),
    form: f("Capsule"),
    categories: [ c("Psychopharmaca"), c("Stimulants") ],
    active_ingredients: [ ai("Methylphenidate Hydrochloride") ],
    notes: "Extended-release formulation of methylphenidate. Uses a bimodal release system (SODAS technology) delivering 50% immediately and 50% delayed. Commonly prescribed for ADHD in children and adults. Avoid administration in the evening to prevent insomnia.",
    versions: [
      { added_name: "20mg", ingredients: [ { name: "Methylphenidate Hydrochloride", amount: 20.0, unit: 0 } ] },
      { added_name: "30mg", ingredients: [ { name: "Methylphenidate Hydrochloride", amount: 30.0, unit: 0 } ] },
      { added_name: "40mg", ingredients: [ { name: "Methylphenidate Hydrochloride", amount: 40.0, unit: 0 } ] }
    ]
  },
  {
    name: "Ritalin IR",
    labeler: l("Novartis"),
    form: f("Tablet"),
    categories: [ c("Psychopharmaca"), c("Stimulants") ],
    active_ingredients: [ ai("Methylphenidate Hydrochloride") ],
    notes: "Immediate-release methylphenidate with a shorter duration of action (3–5 hours). Often used as a complement to long-acting formulations or as a standalone treatment. Onset within 20–30 minutes after ingestion.",
    versions: [
      { added_name: "5mg",  ingredients: [ { name: "Methylphenidate Hydrochloride", amount: 5.0,  unit: 0 } ] },
      { added_name: "10mg", ingredients: [ { name: "Methylphenidate Hydrochloride", amount: 10.0, unit: 0 } ] },
      { added_name: "20mg", ingredients: [ { name: "Methylphenidate Hydrochloride", amount: 20.0, unit: 0 } ] }
    ]
  },
  {
    name: "Adderall XR",
    labeler: l("Shire"),
    form: f("Capsule"),
    categories: [ c("Psychopharmaca"), c("Stimulants") ],
    active_ingredients: [ ai("Amphetamine") ],
    notes: "Mixed amphetamine salts in an extended-release capsule. Duration of action up to 12 hours. The capsule can be opened and sprinkled on food for patients who have difficulty swallowing. Schedule II controlled substance.",
    versions: [
      { added_name: "5mg",  ingredients: [ { name: "Amphetamine", amount: 5.0,  unit: 0 } ] },
      { added_name: "10mg", ingredients: [ { name: "Amphetamine", amount: 10.0, unit: 0 } ] },
      { added_name: "20mg", ingredients: [ { name: "Amphetamine", amount: 20.0, unit: 0 } ] },
      { added_name: "30mg", ingredients: [ { name: "Amphetamine", amount: 30.0, unit: 0 } ] }
    ]
  },
  {
    name: "Vyvanse",
    labeler: l("Shire"),
    form: f("Capsule"),
    categories: [ c("Psychopharmaca"), c("Stimulants") ],
    active_ingredients: [ ai("Lisdexamfetamine") ],
    notes: "Lisdexamfetamine is a prodrug converted to active d-amphetamine in the body, resulting in a smoother onset and lower abuse potential compared to amphetamine. Approved for ADHD and binge eating disorder. Duration of effect approximately 14 hours.",
    versions: [
      { added_name: "20mg", ingredients: [ { name: "Lisdexamfetamine", amount: 20.0, unit: 0 } ] },
      { added_name: "30mg", ingredients: [ { name: "Lisdexamfetamine", amount: 30.0, unit: 0 } ] },
      { added_name: "50mg", ingredients: [ { name: "Lisdexamfetamine", amount: 50.0, unit: 0 } ] },
      { added_name: "70mg", ingredients: [ { name: "Lisdexamfetamine", amount: 70.0, unit: 0 } ] }
    ]
  },
  {
    name: "Strattera",
    labeler: l("Eli Lilly"),
    form: f("Capsule"),
    categories: [ c("Psychopharmaca") ],
    active_ingredients: [ ai("Atomoxetine") ],
    notes: "Non-stimulant ADHD medication and selective norepinephrine reuptake inhibitor (SNRI). Unlike stimulants, it is not a controlled substance and has no abuse potential. Full therapeutic effect may take 4–8 weeks. Suitable for patients with comorbid anxiety or substance use history.",
    versions: [
      { added_name: "10mg", ingredients: [ { name: "Atomoxetine", amount: 10.0, unit: 0 } ] },
      { added_name: "25mg", ingredients: [ { name: "Atomoxetine", amount: 25.0, unit: 0 } ] },
      { added_name: "40mg", ingredients: [ { name: "Atomoxetine", amount: 40.0, unit: 0 } ] },
      { added_name: "60mg", ingredients: [ { name: "Atomoxetine", amount: 60.0, unit: 0 } ] },
      { added_name: "80mg", ingredients: [ { name: "Atomoxetine", amount: 80.0, unit: 0 } ] }
    ]
  },
  {
    name: "Modafinil Teva",
    labeler: l("Teva"),
    form: f("Tablet"),
    categories: [ c("Wakefulness-Promoting Agents"), c("Stimulants"), c("Psychopharmaca") ],
    active_ingredients: [ ai("Modafinil") ],
    notes: "Wakefulness-promoting agent with a mechanism distinct from classical stimulants, primarily acting on the dopamine transporter with additional effects on orexin/hypocretin systems. Approved for narcolepsy, shift work sleep disorder, and obstructive sleep apnea. Also widely used off-label for cognitive enhancement and ADHD. Lower abuse potential than amphetamines.",
    versions: [
      { added_name: "100mg", ingredients: [ { name: "Modafinil", amount: 100.0, unit: 0 } ] },
      { added_name: "200mg", ingredients: [ { name: "Modafinil", amount: 200.0, unit: 0 } ] }
    ]
  },
  {
    name: "Provigil",
    labeler: l("Cephalon"),
    form: f("Tablet"),
    categories: [ c("Wakefulness-Promoting Agents"), c("Stimulants") ],
    active_ingredients: [ ai("Modafinil") ],
    notes: "Brand name modafinil by Cephalon, the original developer. Indicated for narcolepsy, obstructive sleep apnea, and shift work disorder. Provigil was the first modafinil product approved by the FDA in 1998.",
    versions: [
      { added_name: "100mg", ingredients: [ { name: "Modafinil", amount: 100.0, unit: 0 } ] },
      { added_name: "200mg", ingredients: [ { name: "Modafinil", amount: 200.0, unit: 0 } ] }
    ]
  },
  {
    name: "Nuvigil",
    labeler: l("Cephalon"),
    form: f("Tablet"),
    categories: [ c("Wakefulness-Promoting Agents"), c("Stimulants") ],
    active_ingredients: [ ai("Armodafinil") ],
    notes: "Armodafinil is the R-enantiomer of modafinil with a longer half-life, allowing for once-daily dosing and more sustained wakefulness. Approved for the same indications as modafinil. Considered slightly more potent mg-for-mg.",
    versions: [
      { added_name: "50mg",  ingredients: [ { name: "Armodafinil", amount: 50.0,  unit: 0 } ] },
      { added_name: "150mg", ingredients: [ { name: "Armodafinil", amount: 150.0, unit: 0 } ] },
      { added_name: "250mg", ingredients: [ { name: "Armodafinil", amount: 250.0, unit: 0 } ] }
    ]
  },
  {
    name: "Armodacare",
    labeler: l("Teva"),
    form: f("Tablet"),
    categories: [ c("Wakefulness-Promoting Agents"), c("Stimulants") ],
    active_ingredients: [ ai("Armodafinil") ],
    notes: "Brand name armodafinil. Indicated for narcolepsy, obstructive sleep apnea, and shift work sleep disorder. Like Nuvigil, it is the R-enantiomer of modafinil with a longer half-life than racemic modafinil, allowing sustained wakefulness with once-daily dosing.",
    versions: [
      { added_name: "150mg", ingredients: [ { name: "Armodafinil", amount: 150.0, unit: 0 } ] },
      { added_name: "250mg", ingredients: [ { name: "Armodafinil", amount: 250.0, unit: 0 } ] }
    ]
  },
  {
    name: "Zoloft",
    labeler: l("Pfizer"),
    form: f("Film-coated Tablet"),
    categories: [ c("Antidepressants"), c("Psychopharmaca"), c("Anxiolytics") ],
    active_ingredients: [ ai("Sertraline") ],
    notes: "Selective serotonin reuptake inhibitor (SSRI) approved for depression, OCD, panic disorder, PTSD, social anxiety disorder, and premenstrual dysphoric disorder. Generally well-tolerated with a favorable side effect profile. Full antidepressant effect typically seen after 4–6 weeks.",
    versions: [
      { added_name: "25mg",  ingredients: [ { name: "Sertraline", amount: 25.0,  unit: 0 } ] },
      { added_name: "50mg",  ingredients: [ { name: "Sertraline", amount: 50.0,  unit: 0 } ] },
      { added_name: "100mg", ingredients: [ { name: "Sertraline", amount: 100.0, unit: 0 } ] }
    ]
  },
  {
    name: "Prozac",
    labeler: l("Eli Lilly"),
    form: f("Capsule"),
    categories: [ c("Antidepressants"), c("Psychopharmaca") ],
    active_ingredients: [ ai("Fluoxetine") ],
    notes: "One of the most widely prescribed SSRIs. Long half-life (~4–6 days) makes it forgiving of missed doses and allows for once-weekly dosing in some patients. Approved for depression, OCD, bulimia nervosa, and panic disorder. Also used in combination with olanzapine for bipolar depression.",
    versions: [
      { added_name: "10mg", ingredients: [ { name: "Fluoxetine", amount: 10.0, unit: 0 } ] },
      { added_name: "20mg", ingredients: [ { name: "Fluoxetine", amount: 20.0, unit: 0 } ] },
      { added_name: "40mg", ingredients: [ { name: "Fluoxetine", amount: 40.0, unit: 0 } ] }
    ]
  },
  {
    name: "Effexor XR",
    labeler: l("Pfizer"),
    form: f("Capsule"),
    categories: [ c("Antidepressants"), c("Psychopharmaca"), c("Anxiolytics") ],
    active_ingredients: [ ai("Venlafaxine") ],
    notes: "Serotonin-norepinephrine reuptake inhibitor (SNRI) approved for major depressive disorder, generalized anxiety, social anxiety, and panic disorder. Extended-release formulation for once-daily dosing. Discontinuation syndrome can be pronounced — dose tapering is recommended.",
    versions: [
      { added_name: "37.5mg", ingredients: [ { name: "Venlafaxine", amount: 37.5,  unit: 0 } ] },
      { added_name: "75mg",   ingredients: [ { name: "Venlafaxine", amount: 75.0,  unit: 0 } ] },
      { added_name: "150mg",  ingredients: [ { name: "Venlafaxine", amount: 150.0, unit: 0 } ] }
    ]
  },
  {
    name: "Wellbutrin XL",
    labeler: l("AstraZeneca"),
    form: f("Film-coated Tablet"),
    categories: [ c("Antidepressants"), c("Psychopharmaca"), c("Stimulants") ],
    active_ingredients: [ ai("Bupropion") ],
    notes: "Norepinephrine-dopamine reuptake inhibitor (NDRI) with stimulant-like properties. Unlike most antidepressants, it does not cause sexual dysfunction or weight gain — it may promote weight loss. Also approved for smoking cessation. Sometimes used off-label for ADHD.",
    versions: [
      { added_name: "150mg", ingredients: [ { name: "Bupropion", amount: 150.0, unit: 0 } ] },
      { added_name: "300mg", ingredients: [ { name: "Bupropion", amount: 300.0, unit: 0 } ] }
    ]
  },
  {
    name: "Zyrtec",
    labeler: l("Pfizer"),
    form: f("Film-coated Tablet"),
    categories: [ c("Antihistamines") ],
    active_ingredients: [ ai("Cetirizine") ],
    notes: "Second-generation antihistamine with minimal sedation compared to first-generation agents. Indicated for allergic rhinitis and chronic urticaria. Once-daily dosing due to 24-hour duration of action.",
    versions: [
      { added_name: "5mg",  ingredients: [ { name: "Cetirizine", amount: 5.0,  unit: 0 } ] },
      { added_name: "10mg", ingredients: [ { name: "Cetirizine", amount: 10.0, unit: 0 } ] }
    ]
  },
  {
    name: "Ibuprofen Sandoz",
    labeler: l("Sandoz"),
    form: f("Film-coated Tablet"),
    categories: [ c("Analgesics") ],
    active_ingredients: [ ai("Ibuprofen") ],
    notes: "Non-steroidal anti-inflammatory drug (NSAID) for pain, fever, and inflammation. Take with food to reduce gastrointestinal irritation. Avoid in patients with peptic ulcer disease, renal impairment, or cardiovascular disease. Maximum daily dose 2400mg.",
    versions: [
      { added_name: "200mg", ingredients: [ { name: "Ibuprofen", amount: 200.0, unit: 0 } ] },
      { added_name: "400mg", ingredients: [ { name: "Ibuprofen", amount: 400.0, unit: 0 } ] },
      { added_name: "600mg", ingredients: [ { name: "Ibuprofen", amount: 600.0, unit: 0 } ] }
    ]
  },
  {
    name: "Lamictal",
    labeler: l("Pfizer"),
    form: f("Tablet"),
    categories: [ c("Antiepileptics"), c("Psychopharmaca") ],
    active_ingredients: [ ai("Lamotrigine") ],
    notes: "Anticonvulsant also used as a mood stabilizer in bipolar disorder. Dose must be titrated slowly to reduce risk of serious rash (Stevens-Johnson syndrome). Interactions with valproate and enzyme-inducing medications significantly affect dosing. Requires careful monitoring during initiation.",
    versions: [
      { added_name: "25mg",  ingredients: [ { name: "Lamotrigine", amount: 25.0,  unit: 0 } ] },
      { added_name: "50mg",  ingredients: [ { name: "Lamotrigine", amount: 50.0,  unit: 0 } ] },
      { added_name: "100mg", ingredients: [ { name: "Lamotrigine", amount: 100.0, unit: 0 } ] },
      { added_name: "200mg", ingredients: [ { name: "Lamotrigine", amount: 200.0, unit: 0 } ] }
    ]
  },
  {
    name: "Co-codamol",
    labeler: l("Sandoz"),
    form: f("Tablet"),
    categories: [ c("Analgesics") ],
    active_ingredients: [ ai("Paracetamol"), ai("Codeine") ],
    notes: "Combination analgesic containing paracetamol and codeine phosphate. The codeine component provides additional pain relief through opioid receptor agonism. Available in varying codeine strengths. Risk of dependence with prolonged use.",
    versions: [
      {
        added_name: "8/500mg",
        ingredients: [
          { name: "Codeine",     amount: 8.0,   unit: 0 },
          { name: "Paracetamol", amount: 500.0, unit: 0 }
        ]
      },
      {
        added_name: "30/500mg",
        ingredients: [
          { name: "Codeine",     amount: 30.0,  unit: 0 },
          { name: "Paracetamol", amount: 500.0, unit: 0 }
        ]
      }
    ]
  },
  {
    name: "Augmentin",
    labeler: l("Pfizer"),
    form: f("Film-coated Tablet"),
    categories: [ c("Antibiotics") ],
    active_ingredients: [ ai("Amoxicillin"), ai("Clavulanic Acid") ],
    notes: "Combination of amoxicillin and clavulanic acid. Clavulanic acid inhibits beta-lactamase enzymes produced by resistant bacteria, extending the spectrum of amoxicillin to cover organisms that would otherwise be resistant. Commonly used for sinusitis, ear infections, and skin infections.",
    versions: [
      {
        added_name: "375mg",
        ingredients: [
          { name: "Amoxicillin",     amount: 250.0, unit: 0 },
          { name: "Clavulanic Acid", amount: 125.0, unit: 0 }
        ]
      },
      {
        added_name: "625mg",
        ingredients: [
          { name: "Amoxicillin",     amount: 500.0, unit: 0 },
          { name: "Clavulanic Acid", amount: 125.0, unit: 0 }
        ]
      },
      {
        added_name: "1000mg",
        ingredients: [
          { name: "Amoxicillin",     amount: 875.0, unit: 0 },
          { name: "Clavulanic Acid", amount: 125.0, unit: 0 }
        ]
      }
    ]
  },
  {
    name: "Vimovo",
    labeler: l("AstraZeneca"),
    form: f("Film-coated Tablet"),
    categories: [ c("Analgesics"), c("Proton Pump Inhibitors") ],
    active_ingredients: [ ai("Naproxen"), ai("Esomeprazole") ],
    notes: "Fixed-dose combination of the NSAID naproxen and the proton pump inhibitor esomeprazole. The esomeprazole component protects the gastric mucosa from NSAID-induced damage. Indicated for patients who require NSAID therapy but are at risk of gastric ulcers.",
    versions: [
      {
        added_name: "375/20mg",
        ingredients: [
          { name: "Naproxen",     amount: 375.0, unit: 0 },
          { name: "Esomeprazole", amount: 20.0,  unit: 0 }
        ]
      },
      {
        added_name: "500/20mg",
        ingredients: [
          { name: "Naproxen",     amount: 500.0, unit: 0 },
          { name: "Esomeprazole", amount: 20.0,  unit: 0 }
        ]
      }
    ]
  },
  {
    name: "Symbicort",
    labeler: l("AstraZeneca"),
    form: f("Drop"),
    categories: [ c("Antiasthmatics") ],
    active_ingredients: [ ai("Budesonide"), ai("Formoterol") ],
    notes: "Combination inhaled corticosteroid (budesonide) and long-acting beta-agonist (LABA, formoterol) for asthma and COPD maintenance therapy. The corticosteroid reduces airway inflammation while formoterol provides bronchodilation. Not for acute bronchospasm relief.",
    versions: [
      {
        added_name: "80/4.5mcg",
        ingredients: [
          { name: "Budesonide", amount: 80.0, unit: 2 },
          { name: "Formoterol", amount: 4.5,  unit: 2 }
        ]
      },
      {
        added_name: "160/4.5mcg",
        ingredients: [
          { name: "Budesonide", amount: 160.0, unit: 2 },
          { name: "Formoterol", amount: 4.5,   unit: 2 }
        ]
      }
    ]
  },
  {
    name: "Delestrogen",
    labeler: l("Pfizer"),
    form: f("Injection"),
    categories: [ c("Psychopharmaca"), c("Hormone Replacement Therapy") ],
    active_ingredients: [ ai("Estradiol Valerate") ],
    notes: "Estradiol valerate intramuscular injection for hormone replacement therapy and gender-affirming care. Administered as a weekly or bi-weekly intramuscular injection. Provides sustained estrogen levels with a longer duration of action than oral forms due to the valerate ester.",
    versions: [
      { added_name: "5mg/mL",  ingredients: [ { name: "Estradiol Valerate", amount: 5.0,  unit: 3 } ] },
      { added_name: "10mg/mL", ingredients: [ { name: "Estradiol Valerate", amount: 10.0, unit: 3 } ] },
      { added_name: "20mg/mL", ingredients: [ { name: "Estradiol Valerate", amount: 20.0, unit: 3 } ] }
    ]
  }
].each do |m|
  medication = Medication.find_or_create_by(name: m[:name]) do |med|
    med.labeler            = m[:labeler]
    med.form               = m[:form]
    med.categories         = m[:categories]
    med.active_ingredients = m[:active_ingredients]
    med.notes              = m[:notes]
  end

  m[:versions].each do |v|
    version = MedicationVersion.find_or_create_by(added_name: v[:added_name], medication: medication) do |ver|
      ver.added_name = v[:added_name]
      ver.medication = medication
    end

    v[:ingredients].each do |i|
      MedicationVersionIngredient.find_or_create_by(
        medication_version: version,
        active_ingredient:  ActiveIngredient.find_by!(name: i[:name])
      ) do |mvi|
        mvi.amount = i[:amount]
        mvi.unit   = i[:unit]
      end
    end
  end
end
