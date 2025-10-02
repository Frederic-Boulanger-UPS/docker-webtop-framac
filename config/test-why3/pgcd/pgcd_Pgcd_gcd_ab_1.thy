theory pgcd_Pgcd_gcd_ab_1
imports Why3.Why3
begin

why3_open "pgcd_Pgcd_gcd_ab_1.xml"

why3_vc gcd_ab
  using assms
  unfolding is_gcd_def comdiv_def divides_def greaterdiv_def
  sledgehammer
  by (metis add_diff_cancel_left' diff_add_cancel distrib_right)
why3_end

end
