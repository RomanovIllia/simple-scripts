def human_years_cat_years_dog_years(human_years):

    vartype=type(human_years)
    if vartype!=int:
        print "please insert integer type of variable"
    else:
        if human_years<1:
            return "years can't be less than 1, please try again"
        elif human_years==1:
            dogYears=15
            catYears=15
        elif human_years==2:
            dogYears=24
            catYears=24
        else:
            rest_years=human_years-2
            dogYears=24+rest_years*5
            catYears=24+rest_years*4
    print("human years = {}, cat years = {}, dog years = {}".format(human_years, catYears, dogYears))    
    return [human_years,catYears,dogYears]        
human_years_cat_years_dog_years(input("Insert human years: "))


