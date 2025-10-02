theory pgcd_Pgcd_comdiv_ab_1
imports Why3.Why3
begin

why3_open "pgcd_Pgcd_comdiv_ab_1.xml"

why3_vc comdiv_ab
  using assms
  unfolding comdiv_def divides_def
  by algebra  
why3_end

end
