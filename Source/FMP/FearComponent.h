// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Components/ActorComponent.h"
#include "FearComponent.generated.h"

DECLARE_DYNAMIC_MULTICAST_DELEGATE_OneParam(FFearChangedSignature, float, FearLevel);
DECLARE_DYNAMIC_MULTICAST_DELEGATE(FCrySignature);

UCLASS( ClassGroup=(Custom), meta=(BlueprintSpawnableComponent) )
class FMP_API UFearComponent : public UActorComponent
{
	GENERATED_BODY()

public:	
	// Sets default values for this component's properties
	UFearComponent();

protected:
	// Called when the game starts
	virtual void BeginPlay() override;
	virtual void TickComponent(float DeltaTime, ELevelTick TickType, FActorComponentTickFunction* ThisTickFunction) override;

public:	
	
	// Fear values
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Fear")
	float FearLevel = 0.0f;

	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Fear")
	float FearRiseRate = 0.025f;

	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Fear")
	float FearFallRate = 0.04f;

	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Fear")
	bool bIsInDarkness = true;

	// Triggers cry once
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Fear")
	bool bCanCry = true;
	
	//Events
	UPROPERTY(BlueprintAssignable, Category="Fear")
	FFearChangedSignature OnFearChanged;

	UPROPERTY(BlueprintAssignable, Category="Fear")
	FCrySignature OnCry;

	
	UFUNCTION(BlueprintCallable, Category="Fear")
	void SetInDarkness(bool bDark);

	UFUNCTION(BlueprintCallable, Category="Fear")
	float GetFearLevel() const;
	
private:
	
	void UpdateFear(float DeltaTime);
	void HandleCry();

	FTimerHandle CryCooldownTimer;
		
};
