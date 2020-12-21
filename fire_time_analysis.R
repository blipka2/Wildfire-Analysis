# Analysis on time to put out fires

## Libraries

library(ggplot2)

## Check for irregularities in days variable

sum(table(cleanedFire$DURATION_DAYS[ which(cleanedFire$DURATION_DAYS < 0)]))
cleanedFire <- cleanedFire[cleanedFire$DURATION_DAYS >= 0, ]

## Visualizations

### General fire duration by year

ggplot(cleanedFire) + 
  geom_bar(aes(x=FIRE_YEAR, y=DURATION_DAYS, fill=FIRE_SIZE_CLASS), 
           stat = "summary", fun = "mean") + 
  labs(title="Mean Fire Duration by Year", x="Year", y="Mean Fire Duration (Days)") +
  guides(fill=guide_legend(title="Fire Size Classification Code")) +
  theme_light()

### Fire duration by state (alaska, nj, washington)

ggplot(cleanedFire) + 
  geom_bar(aes(x=STATE, y=DURATION_DAYS), 
           stat = "summary", fun = "mean") + 
  labs(title="Mean Fire Duration by State",x="State",y="Mean Fire Duration (Days)") +
  theme_light() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))

### Fire duration by cause

ggplot(cleanedFire) + 
  geom_bar(aes(x=STAT_CAUSE_DESCR, y=DURATION_DAYS, fill=FIRE_SIZE_CLASS), 
           stat="summary", fun="mean") + 
  theme_light() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) + 
  labs(title="Mean Fire Duration by Cause",x="Cause of Fire",y="Mean Fire Duration (Days)") +
  guides(fill=guide_legend(title="Fire Size Classification Code"))

### Fire duration by fire size classification (don't need to show, this is obvious)

ggplot(cleanedFire) +
  geom_bar(aes(x=FIRE_SIZE_CLASS, y=DURATION_DAYS), 
           stat="summary", fun="mean")

### Fire duration by owner description (entity responsible for managing land at point of origin)
### fish and wildlife service, national park service, us forest service
### likely dealing with larger land?

ggplot(cleanedFire) + 
  geom_bar(aes(x=OWNER_DESCR, y=DURATION_DAYS, fill=FIRE_SIZE_CLASS), 
           stat="summary", fun="mean") + 
  theme_light() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) + 
  labs(title="Mean Fire Duration by Owner of Land",x="Owner of Land",y="Mean Fire Duration (Days)")


### Fire duration by county in California
#### maybe show only outliers ???

ggplot(cleanedFire[ which(cleanedFire$STATE=="CA" & is.na(as.numeric(cleanedFire$COUNTY))),]) + 
  geom_bar(aes(x=COUNTY, y=DURATION_DAYS), 
           stat="summary", fun="mean") + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
